function MenuWinget{
    function Test-Winget {
        $wingetPath = Get-Command winget.exe -ErrorAction SilentlyContinue
        if ($wingetPath) {
            Write-Output "Winget está instalado e disponível em: $($wingetPath.Source)"
            return $true
        } else {
            Write-Output "Winget não está instalado ou não está disponível no PATH."
            return $false
        }
    }

    function Test-DesktopAppInstaller {
        $desktopAppInstaller = Get-ChildItem "$env:ProgramFiles\WindowsApps" -Filter "Microsoft.DesktopAppInstaller*" -Directory -ErrorAction SilentlyContinue
        if ($desktopAppInstaller) {
            foreach ($appInstaller in $desktopAppInstaller) {
                Write-Output "Microsoft Desktop App Installer encontrado em: $($appInstaller.FullName)"
            }
            return $true
        } else {
            Write-Output "Microsoft Desktop App Installer não encontrado."
            return $false
        }
    }

    function Install-WingetFromGithub {
        # Verifica se os arquivos já existem na pasta
        if (-not (Test-Winget)) {
            $t = Invoke-WebRequest 'https://api.github.com/repos/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller.msixbundle' -UseBasicParsing
            $null = ($t.content -Match ',"content_type":"application/octet-stream",.*?"browser_download_url":"(.*\.msixbundle)"')
            Invoke-WebRequest $Matches[1] -OutFile .\winget-latest.msixbundle
            Add-AppxPackage .\winget-latest.msixbundle
            Write-Output "Winget instalado com sucesso."
        } else {
            # Se Winget já estiver instalado, tenta atualizá-lo
            Write-Output "Winget já está instalado. Tentando atualizar..."
            winget upgrade winget
        }
    }

    # Testa e instala o Microsoft Desktop App Installer se necessário
    if (-not (Test-DesktopAppInstaller)) {
        $appInstallerUrl = "https://github.com/microsoft/MSIX-Toolkit/releases/latest/download/Microsoft.DesktopAppInstaller.msixbundle"
        try {
            Invoke-WebRequest -Uri $appInstallerUrl -OutFile "Microsoft.DesktopAppInstaller.msixbundle" -ErrorAction Stop
            Add-AppxPackage -Path "Microsoft.DesktopAppInstaller.msixbundle" -ForceInstall
            Write-Output "Microsoft Desktop App Installer adicionado com sucesso."
        } catch {
            Write-Output "Falha ao adicionar o Microsoft Desktop App Installer."
        }
    }

    # Testa e instala o Winget se necessário
    Install-WingetFromGithub

    # Testa novamente o Winget
    Test-Winget
}

