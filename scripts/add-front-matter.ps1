Param(
    [string]$Root = '.'
)

# Find all markdown files, excluding template.md
$mdFiles = Get-ChildItem -Path $Root -Recurse -Include *.md | Where-Object { $_.FullName -notmatch '\\template\.md$' }

foreach ($file in $mdFiles) {
    $path = $file.FullName
    Write-Host "Processing: $path"
    $text = Get-Content -Raw -Path $path -ErrorAction SilentlyContinue
    if ($null -eq $text) { continue }

    # If file already starts with YAML front matter (---) skip
    if ($text.TrimStart().StartsWith('---')) {
        Write-Host "  Already has front matter, skipping."
        continue
    }

    # Determine a sensible title from first heading or filename
    $firstLine = ($text -split "`n")[0].Trim()
    if ($firstLine -match '^#\s+(.*)') { $title = $matches[1].Trim() } else { $title = [System.IO.Path]::GetFileNameWithoutExtension($path) }

    $front = "---`nlayout: default`ntitle: $title`ndescription: $title`n---`n`n"

    # Write new content
    $new = $front + $text
    Set-Content -Path $path -Value $new -Encoding UTF8
    Write-Host "  Front matter added."
}

Write-Host "Done. Review files and commit changes." 
