
function InstallWinGet {
    # Verifica se o pacote Microsoft.DesktopAppInstaller está instalado
    $hasPackageManager = Get-AppPackage -Name "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue

    if ($null -eq $hasPackageManager) {
        Write-Output "Instalando o winget..."
        $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $releases = Invoke-RestMethod -Uri "$($releases_url)"
        $latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1
        
        $wingetPath = "$env:TEMP\winget.msixbundle"
        Invoke-WebRequest -Uri $latestRelease.browser_download_url -OutFile $wingetPath

        Add-AppxPackage -Path $wingetPath
        Write-Output "winget foi instalado com sucesso."
    } else {
        Write-Output "Microsoft.DesktopAppInstaller já está instalado."
    }
}

function Update-WinGet {
    # Verifica se o winget está instalado
    $wingetInstalled = Get-Command winget -ErrorAction SilentlyContinue

    if ($null -ne $wingetInstalled) {
        Write-Output "winget está instalado. Verificando por atualizações..."
        
        # Atualiza o winget utilizando o próprio winget
        winget upgrade --id Microsoft.Winget.Source --silent --accept-source-agreements --accept-package-agreements

        Write-Output "winget foi atualizado com sucesso."
    } else {
        Write-Output "winget não está instalado."
        # Adicione aqui as ações para instalar o winget se necessário
        InstallWinGet
    }
}

function Check-And-InstallWinGet{
    # Verifica se o winget está instalado
    $wingetInstalled = Get-Command winget -ErrorAction SilentlyContinue

    if ($null -ne $wingetInstalled) {
        Write-Output "winget já está instalado."
        # Chama a função Update-WinGet
        Update-WinGet
    } else {
        Write-Output "winget não está instalado."
        # Chama a função InstallWinGet
        InstallWinGet
    }
}

 Check-And-InstallWinGet