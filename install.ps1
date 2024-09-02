#Requires -RunAsAdministrator
#Requires -Version 7

Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

$DOTFILES = $PSScriptRoot

[System.Environment]::SetEnvironmentVariable('DOTFILES', "$DOTFILES", [System.EnvironmentVariableTarget]::User)

mkdir -p "$HOME/.private"

$wingetDeps = @(
	"Chocolatey.Chocolatey"
	"Obsidian.Obsidian"
	"Starship.Starship"
	"wez.wezterm"
)

$chocoDeps = @(
	"fd"
	"mingw"
	"nerd-fonts-NerdFontsSymbolsOnly"
	"ripgrep"
	"victormononf"
)

$symlinks = @{
	"$DOTFILES\git\gitconfig" = "$HOME\.gitconfig"
	"$DOTFILES\nvim" = "$LOCALAPPDATA\nvim"
	"$DOTFILES\pwsh\Profile.ps1" = $PROFILE.CurrentUserAllHosts
}

$psModules = @(
	"CompletionPredictor"
	"PSScriptAnalyzer"
)


Write-Host "Installing missing packages..."

$installedWingetDeps = winget list | Out-String
foreach ($wingetDep in $wingetDeps) {
	if ($installedWingetDeps -notmatch $wingetDep) {
		winget install --id $wingetDep
	}
}

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

$installedChocoDeps = (choco list --limit-output --id-only).Trim().Split("`n")
foreach ($chocoDep in $chocoDeps) {
	if ($installedChocoDeps -notcontains $chocoDep) {
		choco install --id $chocoDep -y
	}
}

foreach ($psModule in $psModules) {
	if (!(Get-Module -ListAvailable -Name $psModule)) {
		Install-Module -Name $psModule -Force -AcceptLicense -Scope CurrentUser
	}
}

Write-Host "Creating Symbolic Links..."
foreach ($symlink in $symlinks.GetEnumerator()) {
	Get-Item -Path $symlink.Value -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
	New-Item -ItemType SymbolicLink -Path $symlink.Value -Target (Resolve-Path $symlink.Key) -Force | Out-Null
}

$wslInstalled = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if ($wslInstalled.State -notmatch "Enable") {
	#wsl --install
	#wsl --install -d Ubuntu-24.04
}


# vim: noet ci pi sts=0 sw=4 ts=4
