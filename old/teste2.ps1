# Fecha o aplicativo Microsoft Desktop App Installer se estiver aberto
Get-Process -Name "Microsoft.DesktopAppInstaller" | Stop-Process -Force -ErrorAction SilentlyContinue

# Baixa o arquivo de instalação do WinGet CLI
Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile '.\Microsoft.DesktopAppInstaller.msixbundle'

# Instala o WinGet CLI
Add-AppxPackage .\Microsoft.DesktopAppInstaller.msixbundle

# Remove o arquivo de instalação após a conclusão
Remove-Item .\Microsoft.DesktopAppInstaller.msixbundle

# Confirmação de instalação
Write-Host "Microsoft WinGet CLI instalado com sucesso!"
