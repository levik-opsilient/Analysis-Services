# Fix AlmToolkit.csproj - Add x64 configs
$file = "AlmToolkit\AlmToolkit.csproj"
[xml]$xml = Get-Content $file
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace("ms", "http://schemas.microsoft.com/developer/msbuild/2003")

$releaseAnyCPU = $xml.SelectSingleNode("//ms:PropertyGroup[@Condition="" '`$(Configuration)|`$(Platform)' == 'Release|AnyCPU' ""]", $ns)

$debugX64 = $xml.CreateElement("PropertyGroup", $xml.DocumentElement.NamespaceURI)
$debugX64.SetAttribute("Condition", " '`$(Configuration)|`$(Platform)' == 'Debug|x64' ")
$debugX64.InnerXml = "<PlatformTarget>x64</PlatformTarget><DebugSymbols>true</DebugSymbols><DebugType>full</DebugType><Optimize>false</Optimize><OutputPath>bin\x64\Debug\</OutputPath><DefineConstants>DEBUG;TRACE</DefineConstants><ErrorReport>prompt</ErrorReport><WarningLevel>4</WarningLevel>"

$releaseX64 = $xml.CreateElement("PropertyGroup", $xml.DocumentElement.NamespaceURI)
$releaseX64.SetAttribute("Condition", " '`$(Configuration)|`$(Platform)' == 'Release|x64' ")
$releaseX64.InnerXml = "<PlatformTarget>x64</PlatformTarget><DebugType>pdbonly</DebugType><Optimize>true</Optimize><OutputPath>bin\x64\Release\</OutputPath><DefineConstants>TRACE</DefineConstants><ErrorReport>prompt</ErrorReport><WarningLevel>4</WarningLevel>"

$xml.Project.InsertAfter($debugX64, $releaseAnyCPU)
$xml.Project.InsertAfter($releaseX64, $debugX64)
$xml.Save((Resolve-Path $file).Path)
Write-Host "Added x64 to AlmToolkit.csproj"

# Fix BismNormalizer.csproj - Add x64 configs and CefSharpAnyCpuSupport
$file = "BismNormalizer\BismNormalizer.csproj"
[xml]$xml = Get-Content $file
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace("ms", "http://schemas.microsoft.com/developer/msbuild/2003")

# Add CefSharpAnyCpuSupport
$firstPropGroup = $xml.SelectSingleNode("//ms:PropertyGroup[1]", $ns)
$cefNode = $xml.CreateElement("CefSharpAnyCpuSupport", $xml.DocumentElement.NamespaceURI)
$cefNode.InnerText = "true"
$firstPropGroup.AppendChild($cefNode) | Out-Null

$releaseAnyCPU = $xml.SelectSingleNode("//ms:PropertyGroup[@Condition="" '`$(Configuration)|`$(Platform)' == 'Release|AnyCPU' ""]", $ns)

$debugX64 = $xml.CreateElement("PropertyGroup", $xml.DocumentElement.NamespaceURI)
$debugX64.SetAttribute("Condition", " '`$(Configuration)|`$(Platform)' == 'Debug|x64' ")
$debugX64.InnerXml = "<DebugSymbols>true</DebugSymbols><DebugType>full</DebugType><Optimize>false</Optimize><OutputPath>bin\x64\Debug\</OutputPath><DefineConstants>DEBUG;TRACE</DefineConstants><ErrorReport>prompt</ErrorReport><WarningLevel>4</WarningLevel><PlatformTarget>x64</PlatformTarget>"

$releaseX64 = $xml.CreateElement("PropertyGroup", $xml.DocumentElement.NamespaceURI)
$releaseX64.SetAttribute("Condition", " '`$(Configuration)|`$(Platform)' == 'Release|x64' ")
$releaseX64.InnerXml = "<DebugType>pdbonly</DebugType><Optimize>true</Optimize><OutputPath>bin\x64\Release\</OutputPath><DefineConstants>TRACE</DefineConstants><ErrorReport>prompt</ErrorReport><WarningLevel>4</WarningLevel><PlatformTarget>x64</PlatformTarget>"

$xml.Project.InsertAfter($debugX64, $releaseAnyCPU)
$xml.Project.InsertAfter($releaseX64, $debugX64)
$xml.Save((Resolve-Path $file).Path)
Write-Host "Added x64 and CefSharpAnyCpuSupport to BismNormalizer.csproj"

# Fix BismNormalizer.CommandLine.csproj - Add x64 configs and CefSharpAnyCpuSupport
$file = "BismNormalizer.CommandLine\BismNormalizer.CommandLine.csproj"
[xml]$xml = Get-Content $file
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace("ms", "http://schemas.microsoft.com/developer/msbuild/2003")

# Add CefSharpAnyCpuSupport
$firstPropGroup = $xml.SelectSingleNode("//ms:PropertyGroup[1]", $ns)
$cefNode = $xml.CreateElement("CefSharpAnyCpuSupport", $xml.DocumentElement.NamespaceURI)
$cefNode.InnerText = "true"
$firstPropGroup.AppendChild($cefNode) | Out-Null

$releaseAnyCPU = $xml.SelectSingleNode("//ms:PropertyGroup[@Condition="" '`$(Configuration)|`$(Platform)' == 'Release|AnyCPU' ""]", $ns)

$debugX64 = $xml.CreateElement("PropertyGroup", $xml.DocumentElement.NamespaceURI)
$debugX64.SetAttribute("Condition", " '`$(Configuration)|`$(Platform)' == 'Debug|x64' ")
$debugX64.InnerXml = "<PlatformTarget>x64</PlatformTarget><DebugSymbols>true</DebugSymbols><DebugType>full</DebugType><Optimize>false</Optimize><OutputPath>bin\x64\Debug\</OutputPath><DefineConstants>DEBUG;TRACE</DefineConstants><ErrorReport>prompt</ErrorReport><WarningLevel>4</WarningLevel>"

$releaseX64 = $xml.CreateElement("PropertyGroup", $xml.DocumentElement.NamespaceURI)
$releaseX64.SetAttribute("Condition", " '`$(Configuration)|`$(Platform)' == 'Release|x64' ")
$releaseX64.InnerXml = "<PlatformTarget>x64</PlatformTarget><DebugType>pdbonly</DebugType><Optimize>true</Optimize><OutputPath>bin\x64\Release\</OutputPath><DefineConstants>TRACE</DefineConstants><ErrorReport>prompt</ErrorReport><WarningLevel>4</WarningLevel>"

$xml.Project.InsertAfter($debugX64, $releaseAnyCPU)
$xml.Project.InsertAfter($releaseX64, $debugX64)
$xml.Save((Resolve-Path $file).Path)
Write-Host "Added x64 and CefSharpAnyCpuSupport to BismNormalizer.CommandLine.csproj"

# Fix solution file mappings
$file = "AlmToolkit.sln"
$content = Get-Content $file -Raw
$content = $content -replace "\{8E68FB9B-73DF-4BC3-9C56-760C87078D13\}\.Debug\|x64\.ActiveCfg = Debug\|Any CPU", "{8E68FB9B-73DF-4BC3-9C56-760C87078D13}.Debug|x64.ActiveCfg = Debug|x64"
$content = $content -replace "\{8E68FB9B-73DF-4BC3-9C56-760C87078D13\}\.Debug\|x64\.Build\.0 = Debug\|Any CPU", "{8E68FB9B-73DF-4BC3-9C56-760C87078D13}.Debug|x64.Build.0 = Debug|x64"
$content = $content -replace "\{8E68FB9B-73DF-4BC3-9C56-760C87078D13\}\.Release\|x64\.ActiveCfg = Release\|Any CPU", "{8E68FB9B-73DF-4BC3-9C56-760C87078D13}.Release|x64.ActiveCfg = Release|x64"
$content = $content -replace "\{8E68FB9B-73DF-4BC3-9C56-760C87078D13\}\.Release\|x64\.Build\.0 = Release\|Any CPU", "{8E68FB9B-73DF-4BC3-9C56-760C87078D13}.Release|x64.Build.0 = Release|x64"
$content = $content -replace "\{4C77E665-FA37-4793-8950-69AABD3DC626\}\.Debug\|x64\.ActiveCfg = Debug\|Any CPU", "{4C77E665-FA37-4793-8950-69AABD3DC626}.Debug|x64.ActiveCfg = Debug|x64"
$content = $content -replace "\{4C77E665-FA37-4793-8950-69AABD3DC626\}\.Debug\|x64\.Build\.0 = Debug\|Any CPU", "{4C77E665-FA37-4793-8950-69AABD3DC626}.Debug|x64.Build.0 = Debug|x64"
$content = $content -replace "\{4C77E665-FA37-4793-8950-69AABD3DC626\}\.Release\|x64\.ActiveCfg = Release\|Any CPU", "{4C77E665-FA37-4793-8950-69AABD3DC626}.Release|x64.ActiveCfg = Release|x64"
$content = $content -replace "\{4C77E665-FA37-4793-8950-69AABD3DC626\}\.Release\|x64\.Build\.0 = Release\|Any CPU", "{4C77E665-FA37-4793-8950-69AABD3DC626}.Release|x64.Build.0 = Release|x64"
Set-Content $file -Value $content -NoNewline
Write-Host "Updated AlmToolkit.sln mappings"

Write-Host "`nAll fixes applied successfully!"
