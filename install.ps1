<#
.SYNOPSIS
    Installs native Windows apps and links dotfiles configs.

.NOTES
    Uses Junctions for directories and HardLinks for files — no admin or Developer Mode required.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function New-Link {
    param(
        [string]$Target,
        [string]$Link
    )

    $parent = Split-Path -Parent $Link
    if (!(Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    if (Test-Path $Link -PathType Any) {
        $item = Get-Item $Link -Force
        if ($item.LinkType -eq "SymbolicLink" -and (Resolve-Path $item.Target -ErrorAction SilentlyContinue) -eq (Resolve-Path $Target)) {
            return
        }
        Remove-Item $Link -Recurse -Force
    }

    $isDir = Test-Path $Target -PathType Container
    $type  = if ($isDir) { "Junction" } else { "HardLink" }
    New-Item -ItemType $type -Path $Link -Target $Target | Out-Null
}

function Add-ScoopBucket {
    param([string]$Name)
    if (scoop bucket list | Select-String "^$Name ") { return }
    scoop bucket add $Name
}

function Install-ScoopPackage {
    param([string]$Name)
    if (scoop list | Select-String "^$Name ") { return }
    scoop install $Name
}

# -------------------------------
#   Scoop for Windows - https://scoop.sh/
# -------------------------------

if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod https://get.scoop.sh | Invoke-Expression
    $env:PATH = "$env:USERPROFILE\scoop\shims;$env:PATH"
}

Add-ScoopBucket extras
Add-ScoopBucket versions
Add-ScoopBucket nerd-fonts

$Packages = @(
    "extras/claude",
    "extras/googlechrome",
    "extras/keepassxc",
    "extras/neovim",
    "extras/obsidian",
    "extras/spotify",
    "extras/vscode",
    "extras/wezterm",
    "main/nodejs",
    "nerd-fonts/NerdFontsSymbolsOnly"
    "nerd-fonts/Victor-Mono",
    "versions/firefox-developer"
)

foreach ($pkg in $Packages) {
    Install-ScoopPackage $pkg
}

# SSH

$SshType = "ed25519"
$SshDir  = "$env:USERPROFILE\.ssh"
$SshKey  = "$SshDir\id_$SshType"
if (!(Test-Path $SshKey)) {
    New-Item -ItemType Directory -Path $SshDir -Force | Out-Null
    ssh-keygen -t $SshType -N '""' -f $SshKey -C $env:COMPUTERNAME
}

# Git

$PrivateDir = "$env:USERPROFILE\.private"
$GitPrivate = "$PrivateDir\gitconfig"
if (!(Test-Path $GitPrivate)) {
    New-Item -ItemType Directory -Path $PrivateDir -Force | Out-Null
    $Name  = Read-Host "Enter your name"
    $Email = Read-Host "Enter your email"
    @"
[user]
	email = $Email
	name = $Name
"@ | Set-Content $GitPrivate -Encoding UTF8
}

# Symlinks

New-Link "$ScriptDir\git\gitconfig"       "$env:USERPROFILE\.gitconfig"
New-Link "$ScriptDir\wezterm\wezterm.lua" "$env:USERPROFILE\.wezterm.lua"

git -C $ScriptDir remote set-url origin git@github.com:maturanomx/.dotfiles.git
