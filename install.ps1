# Set permissions to execute this script
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

function Restart-AsAdmin {
		param (
		[string]$adminSectionStartLabel
		)

		$scriptPath = $PSCommandPath
		$scriptContent = Get-Content -Path $scriptPath -Raw
		$adminSection = $scriptContent -split "#### $adminSectionStartLabel" | Select-Object -Last 1

		$tempScriptPath = [System.IO.Path]::GetTempFileName() + '.ps1'
		Set-Content -Path $tempScriptPath -Value $adminSection

		Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tempScriptPath`"" -Verb RunAs
		exit
	}

function Set-UserEnvironmentVariable {
	param (
		[string]$name,
		[string]$value
	)
	[System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::User)
}

Write-Host 'Setting Environment variables...'
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot
$DOTFILES = $PSScriptRoot


Set-UserEnvironmentVariable 'BAT_CONFIG_DIR' (Join-Path $DOTFILES 'bat')
Set-UserEnvironmentVariable 'DOTFILES' $DOTFILES
Set-UserEnvironmentVariable 'MISE_GLOBAL_CONFIG_FILE' (Join-Path $DOTFILES 'mise\config.toml')
Set-UserEnvironmentVariable 'OBSIDIAN_VAULT' (Join-Path $HOME 'projects\brainotes')
Set-UserEnvironmentVariable 'STARSHIP_CONFIG' (Join-Path $DOTFILES 'zsh\starship.toml')
Set-UserEnvironmentVariable 'WEZTERM_CONFIG_FILE' (Join-Path $DOTFILES 'wezterm\wezterm.lua')


if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
	scoop install git
}

$requiredBuckets = @("extras", "main", "nerd-fonts", "versions")
$existingBuckets = scoop bucket list
foreach ($bucket in $requiredBuckets) {
    if (-not ($existingBuckets -match "\b$bucket\b")) {
        scoop bucket add $bucket
    }
}


# autohotkey
#"Microsoft.PowerShell"
#"mingw"
#"tree-sitter"
$requiredApps = @(
	"bat"
	"curl"
	"fd"
	"firefox-developer"
	"fzf"
	"gcc"
	"gsudo"
	"keepassxc"
	"lazygit"
	"less"
	"mise"
	"neovim"
	"NerdFontsSymbolsOnly"
	"obsidian"
	"psfzf"
	"pwsh"
	"ripgrep"
	"spotify"
	"starship"
	"vcredist2022"
	"Victor-Mono"
	"vscode"
	"wezterm"
	"wget"
	"zoxide"
)
$installedApps = scoop list
foreach ($app in $requiredApps) {
	$installed = $installedApps | Select-String -SimpleMatch $app
	$failed = $installed -match "Install failed"

    if (-not $installed -or $failed) {
        scoop install $app
    }
}


$psModules = @("PowerShellGet", "CompletionPredictor", "ps-color-scripts", "PSScriptAnalyzer")
foreach ($psModule in $psModules) {
	if (!(Get-Module -ListAvailable -Name $psModule)) {
		Install-Module -Name $psModule -Force -Scope CurrentUser -Confirm:$false
	}
}


$privateDir = Join-Path $env:USERPROFILE ".private"
$gitConfigPath = Join-Path $privateDir 'gitconfig'
if (-Not (Test-Path $gitConfigPath)) {
	if (-not (Test-Path $privateDir)) {
    	New-Item -ItemType Directory -Path $privateDir -Force
	}

	do { $name = Read-Host "Enter you name" } while (-not $name)
	do { $email = Read-Host "Enter your email" } while (-not $email)
	@"
[user]
	email = $email
	name = $name
"@ | Set-Content $gitConfigPath
}

$sshType = "ed25519"
$sshFile = Join-Path $env:USERPROFILE ".ssh\id_$sshType"
if (-not (Test-Path -Path $sshFile)) {
	$sshDir = Join-Path $env:USERPROFILE ".ssh"
	if (-not (Test-Path $sshDir)) {
    	New-Item -ItemType Directory -Path $sshDir -Force
	}

	ssh-keygen -t $sshType -f $sshFile -C "$(hostname)"
}


# Delete OOTB Neovim Shortcuts
if (Test-Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\") {
	Remove-Item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Neovim\" -Recurse -Force
}

bat cache --clear
bat cache --build
# mise install


#### ADMIN_PRIVILEGES_REQUIRED_FROM_HERE
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Restart-AsAdmin 'ADMIN_PRIVILEGES_REQUIRED_FROM_HERE'
}

$symlinks = @{
	(Join-Path $DOTFILES 'git\gitconfig') = Join-Path $env:USERPROFILE '.gitconfig'
	(Join-Path $DOTFILES 'nvim') = Join-Path $env:LOCALAPPDATA 'nvim'
	(Join-Path $DOTFILES 'pwsh\Profile.ps1') = $PROFILE.CurrentUserAllHosts
}

foreach ($symlink in $symlinks.GetEnumerator()) {
	$source = $symlink.Name
	$target = $symlink.Value
	if (Test-Path $target) {
		Remove-Item -Path $target -Force -Recurse -ErrorAction SilentlyContinue
	}
	New-Item -ItemType SymbolicLink -Path $target -Target $source
}


Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -ErrorAction Stop
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -ErrorAction Stop


# TODO: Review
try {
	wsl --install
} catch {
	Write-Host "An error occurred during WSL installation: $_"
	exit
}


# Revert permissions to execute external scripts
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted

# vim: noet ci pi sts=0 sw=4 ts=4
