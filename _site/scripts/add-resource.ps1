Param(
    [Parameter(Mandatory=$true)]
    [string]$Section,    # folder name e.g. "3dprints"
    [Parameter(Mandatory=$true)]
    [string]$ResourceName,# file name without extension e.g. "my-print"
    [string]$Title,       # optional display title; defaults to ResourceName
    [string]$DownloadUrl  # optional download url
)

# Paths
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path "$repoRoot\..")
$template = Join-Path $repoRoot 'template.md'
$sectionDir = Join-Path $repoRoot $Section
$destFile = Join-Path $sectionDir ($ResourceName + '.md')
$indexFile = Join-Path $sectionDir 'index.md'

if (-not (Test-Path $template)) {
    Write-Error "template.md not found at $template"
    exit 1
}

if (-not (Test-Path $sectionDir)) {
    Write-Host "Section folder '$Section' does not exist. Creating..."
    New-Item -ItemType Directory -Path $sectionDir | Out-Null
}

if (Test-Path $destFile) {
    Write-Error "Destination file already exists: $destFile"
    exit 1
}

Copy-Item $template $destFile

# Replace Title if provided
if ([string]::IsNullOrWhiteSpace($Title)) { $Title = $ResourceName }

$content = Get-Content -Raw -Path $destFile
$content = $content -replace '# Template', "# $Title"

if (-not [string]::IsNullOrWhiteSpace($DownloadUrl)) {
    $content = $content -replace '\[link\]\(link\)', "[Download]($DownloadUrl)"
}

Set-Content -Path $destFile -Value $content -Encoding UTF8

Write-Host "Created resource file: $destFile"

# Update section index.md
if (-not (Test-Path $indexFile)) {
    # create a basic index if missing
    @("# $Section`n","## Resources`n") | Out-File -FilePath $indexFile -Encoding UTF8
}

$indexLines = Get-Content -Path $indexFile -ErrorAction Stop

# Prepare the link line
$linkLine = "- [$Title]($ResourceName.md)"

# Find the '## Resources' heading index
$resourcesHeadingIndex = $indexLines | ForEach-Object {$_} | Select-Object -Index ((0..($indexLines.Count - 1)) | Where-Object { $indexLines[$_] -match '^##\s+Resources' } ) -ErrorAction SilentlyContinue

if ($null -eq $resourcesHeadingIndex) {
    # if no resources heading, append one and then insert
    Add-Content -Path $indexFile -Value "`n## Resources`n$linkLine"
    Write-Host "Created '## Resources' and added link to index: $indexFile"
} else {
    # compute insertion point: the line after the heading
    $headingLineNumber = ($indexLines | Select-Object -Index 0..($indexLines.Count-1) | Where-Object { $indexLines[$_] -match '^##\s+Resources' } | Select-Object -First 1)
    if ($null -eq $headingLineNumber) { $headingLineNumber = ($indexLines | Select-String '^##\s+Resources' | Select-Object -First 1).LineNumber - 1 }
    if ($headingLineNumber -eq $null) { $headingLineNumber = 0 }

    # Build new list: keep existing list items under resources, insert new one at top
    # Find the block of list items starting after heading until next blank line or next heading
    $start = $headingLineNumber + 1
    $i = $start
    $listItems = @()
    while ($i -lt $indexLines.Count) {
        $line = $indexLines[$i]
        if ($line -match '^#' -or $line -match '^##') { break }
        if ($line.Trim().Length -gt 0) { $listItems += $line }
        $i++
    }

    # Remove any existing identical link if present
    $listItems = $listItems | Where-Object { $_ -ne $linkLine }

    # Prepend the new link
    $newList = ,$linkLine + $listItems

    # Trim to 5 items
    if ($newList.Count -gt 5) { $newList = $newList[0..4] }

    # Reconstruct file: lines up to start, then newList, then remaining lines from i onwards
    $before = if ($start -gt 0) { $indexLines[0..($start-1)] } else { @() }
    $after = if ($i -lt $indexLines.Count) { $indexLines[$i..($indexLines.Count-1)] } else { @() }

    $out = @()
    $out += $before
    # ensure there's a blank line after heading
    if ($before[-1].Trim().Length -gt 0) { $out += '' }
    $out += $newList
    $out += ''
    $out += $after

    Set-Content -Path $indexFile -Value ($out -join "`n") -Encoding UTF8
    Write-Host "Inserted link under '## Resources' and trimmed list to 5 items in $indexFile"
}

Write-Host "Done. Review $destFile and $indexFile, then commit your changes." 
