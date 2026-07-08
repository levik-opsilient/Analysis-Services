function Wait-FileUnlock {
	param([string]$FilePath)
	$attempts = 0
	$maxAttempts = 10
	while ($attempts -lt $maxAttempts) {
		try {
			$file = [System.IO.File]::Open($FilePath, 'Open', 'ReadWrite', 'None')
			$file.Close()
			return $true
		}
		catch {
			Write-Host "File locked, waiting... (attempt $($attempts + 1)/$maxAttempts)"
			Start-Sleep -Seconds 1
			$attempts++
		}
	}
	return $false
}

function Add-CefSharpAnyCpuSupport {
	param([string]$ProjectFile)

	Write-Host "`nProcessing: $ProjectFile"

	# Wait for file to be unlocked
	if (-not (Wait-FileUnlock $ProjectFile)) {
		Write-Host "ERROR: Could not access file after waiting. Please close Visual Studio and try again." -ForegroundColor Red
		return $false
	}

	# Read the file
	$content = Get-Content $ProjectFile -Raw

	# Check if CefSharpAnyCpuSupport already exists
	if ($content -match '<CefSharpAnyCpuSupport>') {
		Write-Host "CefSharpAnyCpuSupport already exists in $ProjectFile" -ForegroundColor Yellow
		return $true
	}

	# Use XML to properly add the element
	[xml]$xml = $content
	$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
	$ns.AddNamespace("ms", "http://schemas.microsoft.com/developer/msbuild/2003")

	# Get first PropertyGroup
	$firstPropGroup = $xml.SelectSingleNode("//ms:PropertyGroup[1]", $ns)

	if ($null -eq $firstPropGroup) {
		Write-Host "ERROR: Could not find PropertyGroup in $ProjectFile" -ForegroundColor Red
		return $false
	}

	# Create new element
	$cefElement = $xml.CreateElement("CefSharpAnyCpuSupport", "http://schemas.microsoft.com/developer/msbuild/2003")
	$cefElement.InnerText = "true"

	# Add to PropertyGroup
	$firstPropGroup.AppendChild($cefElement) | Out-Null

	# Save with retry
	$saved = $false
	$saveAttempts = 0
	while (-not $saved -and $saveAttempts -lt 5) {
		try {
			$xml.Save((Resolve-Path $ProjectFile).Path)
			$saved = $true
			Write-Host "Successfully added CefSharpAnyCpuSupport to $ProjectFile" -ForegroundColor Green
		}
		catch {
			Write-Host "Save failed, retrying... (attempt $($saveAttempts + 1)/5)" -ForegroundColor Yellow
			Start-Sleep -Seconds 2
			$saveAttempts++
		}
	}

	return $saved
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CefSharp AnyCPU Support Fixer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$projectFiles = @(
	"AlmToolkit\BismNormalizer\BismNormalizer.csproj",
	"AlmToolkit\BismNormalizer.CommandLine\BismNormalizer.CommandLine.csproj"
)

$allSuccess = $true
foreach ($project in $projectFiles) {
	$fullPath = Join-Path $PSScriptRoot $project
	if (Test-Path $fullPath) {
		$result = Add-CefSharpAnyCpuSupport -ProjectFile $fullPath
		if (-not $result) {
			$allSuccess = $false
		}
	}
	else {
		Write-Host "ERROR: File not found: $fullPath" -ForegroundColor Red
		$allSuccess = $false
	}
}

Write-Host "`n========================================" -ForegroundColor Cyan
if ($allSuccess) {
	Write-Host "All files updated successfully!" -ForegroundColor Green
	Write-Host "You can now build the solution." -ForegroundColor Green
}
else {
	Write-Host "Some files could not be updated." -ForegroundColor Red
	Write-Host "Please close Visual Studio and run this script again." -ForegroundColor Yellow
}
Write-Host "========================================" -ForegroundColor Cyan
