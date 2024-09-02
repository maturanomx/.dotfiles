Remove-Item Alias:cat -ErrorAction SilentlyContinue
Set-Alias -Name cat -Value bat
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim

Invoke-Expression (& { (mise activate pwsh | Out-String) })
Invoke-Expression (& { (starship init powershell | Out-String) })
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

# vim: noet ci pi sts=0 sw=4 ts=4
