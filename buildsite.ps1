mkdocs build

# Define paths
$DocsFolder = ".\docs\en-US"
$MkDocsFile = ".\mkdocs.yml"
$ChangelogFile = ".\CHANGELOG.md"
$ChangelogFolder = ".\docs\CHANGELOG"

# Ensure the changelog folder exists
if (-not (Test-Path -Path $ChangelogFolder)) {
    New-Item -ItemType Directory -Path $ChangelogFolder
}

# Copy the changelog file to the changelog folder
Copy-Item -Path $ChangelogFile -Destination "$ChangelogFolder\CHANGELOG.md" -Force

# Read existing mkdocs.yml content
$MkDocsContent = Get-Content -Path $MkDocsFile -Raw

# Initialize the Commands section
$CommandsNav = @()
$MarkdownFiles = Get-ChildItem -Path $DocsFolder -Filter *.md | Sort-Object Name

foreach ($File in $MarkdownFiles) {
    # Extract the title from the first line starting with "# "
    try {
        $Title = (Select-String -Path $File.FullName -Pattern "^#\s*(.*)" -ErrorAction Stop).Matches.Groups[1].Value.Trim()
        if (-not $Title) {
            throw "Title extraction failed; title is empty."
        }
    } catch {
        Write-Host "Error extracting title from $($File.Name): $_" -ForegroundColor Red
        continue  # Skip this file and move to the next
    }

    # Add the file to the navigation
    $FilePath = "en-US/$($File.Name)"
    $CommandsNav += "      - $Title`: $FilePath"
}

# Combine the CommandsNav array into a single string for insertion
$CommandsNavString = $CommandsNav -join "`n"

# Update the Commands section in mkdocs.yml
if ($MkDocsContent -match "  - Commands:") {
    $MkDocsContent = $MkDocsContent -replace "(  - Commands:\s*(?:\s{6}- .+\n)+)", "  - Commands:`n$CommandsNavString`n"
} else {
    Write-Host "Commands section not found, adding new section." -ForegroundColor Yellow
    $MkDocsContent = $MkDocsContent -replace "(nav:\s*\n)", "`$1  - Commands:`n$CommandsNavString`n"
}

# Ensure Changelog is in the navigation
if ($MkDocsContent -notmatch "  - Changelog:") {
    $MkDocsContent = $MkDocsContent -replace "(nav:\s*\n)", "`$1  - Changelog: CHANGELOG/CHANGELOG.md`n"
}

# Save the updated mkdocs.yml
$MkDocsContent | Set-Content -Path $MkDocsFile -Encoding UTF8

Write-Host "mkdocs.yml updated successfully!" -ForegroundColor Green
