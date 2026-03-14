# Copy CareCue branding images from Cursor's saved assets into branding_site/images.
# Run from: branding_site folder (or repo root).
# Requires: source assets at $env:USERPROFILE\.cursor\projects\...\assets

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$destDir = Join-Path $scriptDir "images"
$projectName = "d-Projects-Personal-Vantage-Solutions-Apps-CareCue"
$assetsDir = Join-Path $env:USERPROFILE ".cursor\projects\$projectName\assets"

if (-not (Test-Path $assetsDir)) {
    Write-Warning "Assets folder not found: $assetsDir"
    Write-Host "Create branding_site/images and add logo/screenshots manually. See images/README.md"
    exit 0
}

$prefix = "c__Users_*_AppData_Roaming_Cursor_User_workspaceStorage_*_images_"

$mappings = @(
    @{ Pattern = "*carecue_logo*"; Dest = "carecue_logo.png" },
    @{ Pattern = "*CareCue_feature*"; Dest = "CareCue_feature.png" },
    @{ Pattern = "*00.56.44-1f378b89*"; Dest = "screenshot_welcome.png" },
    @{ Pattern = "*00.56.46-ea392755*"; Dest = "screenshot_water_intake.png" },
    @{ Pattern = "*00.56.45__1_-f7582c19*"; Dest = "screenshot_water_reminders.png" },
    @{ Pattern = "*00.56.46__1_-44b3436d*"; Dest = "screenshot_dashboard.png" },
    @{ Pattern = "*21.54.06-278e733b*"; Dest = "screenshot_sleep.png" },
    @{ Pattern = "*00.56.47-f4f4ae99*"; Dest = "screenshot_settings.png" }
)

New-Item -ItemType Directory -Path $destDir -Force | Out-Null

foreach ($m in $mappings) {
    $found = Get-ChildItem -Path $assetsDir -Filter $m.Pattern -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $destPath = Join-Path $destDir $m.Dest
        try {
            # Use long path prefix for source if path is very long (Windows MAX_PATH)
            $srcPath = $found.FullName
            if ($srcPath.Length -gt 240 -and -not $srcPath.StartsWith("\\?\")) {
                $srcPath = "\\?\$srcPath"
            }
            [System.IO.File]::Copy($srcPath, $destPath, $true)
            Write-Host "Copied: $($m.Dest)"
        } catch {
            Write-Warning "Copy failed for $($m.Dest): $_"
        }
    } else {
        Write-Host "Skip (not found): $($m.Dest)"
    }
}

Write-Host "Done. Images in: $destDir"
