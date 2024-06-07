
# Função para exibir o menu e capturar a escolha do usuário
function Show-Menu-Java {
    param (
        [string]$Title = 'Instalação/Atualização de Java'
    )

    Write-Host "============================="
    Write-Host " $Title"
    Write-Host "============================="
    Write-Host "1. Instalar/Atualizar OpenJDK 8 e JRE 8"
    Write-Host "2. Instalar/Atualizar OpenJDK 11 e JRE 11"
    Write-Host "3. Instalar/Atualizar OpenJDK 17 e JRE 17"
    Write-Host "4. Instalar/Atualizar OpenJDK 21 e JRE 21"
    Write-Host "0. Sair"
    Write-Host "============================="
    $choice = Read-Host "Digite o número da sua escolha"
    return $choice
}

function Check-JavaVersions {
    Write-Host "Verificando versões instaladas de Java..."

    # Função auxiliar para verificar uma chave de registro específica
    function Get-JavaVersionFromRegistry {
        param (
            [string]$RegistryPath
        )
        $javaVersions = @()
        if (Test-Path $RegistryPath) {
            $javaKeys = Get-ChildItem -Path $RegistryPath
            foreach ($key in $javaKeys) {
                $version = Get-ItemProperty -Path $key.PSPath -Name "JavaHome" -ErrorAction SilentlyContinue
                if ($null -ne $version) {
                    $javaVersions += [PSCustomObject]@{
                        Version = $key.PSChildName
                        Path    = $version.JavaHome
                    }
                }
            }
        }
        return $javaVersions
    }

    # Checa versões do Java no registro do Windows
    $javaRegistryPaths = @(
        "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment",
        "HKLM:\SOFTWARE\JavaSoft\Java Development Kit",
        "HKLM:\SOFTWARE\WOW6432Node\JavaSoft\Java Runtime Environment",
        "HKLM:\SOFTWARE\WOW6432Node\JavaSoft\Java Development Kit"
    )

    $installedJavaVersions = @()
    foreach ($path in $javaRegistryPaths) {
        $installedJavaVersions += Get-JavaVersionFromRegistry -RegistryPath $path
    }

    # Exibe as versões encontradas
    if ($installedJavaVersions.Count -eq 0) {
        Write-Host "Nenhuma versão do Java foi encontrada."
    } else {
        Write-Host "Versões instaladas do Java:"
        foreach ($version in $installedJavaVersions) {
            Write-Host "Versão: $($version.Version), Caminho: $($version.Path)"
        }
    }
}



# Função para instalar JDK e JRE usando winget
function Install-JDKandJRE {
    param (
        [string]$version
    )

    switch ($version) {
        "8" {
            Write-Host "Instalando/Atualizando OpenJDK 8 e JRE 8 usando winget..."
            winget install --id EclipseAdoptium.Temurin.8.JDK -e --silent
            winget install --id EclipseAdoptium.Temurin.8.JRE -e --silent
        }
        "11" {
            Write-Host "Instalando/Atualizando OpenJDK 11 e JRE 11 usando winget..."
            winget install --id EclipseAdoptium.Temurin.11.JDK -e --silent
            winget install --id EclipseAdoptium.Temurin.11.JRE -e --silent
        }
        "17" {
            Write-Host "Instalando/Atualizando OpenJDK 17 e JRE 17 usando winget..."
            winget install --id EclipseAdoptium.Temurin.17.JDK -e --silent
            winget install --id EclipseAdoptium.Temurin.17.JRE -e --silent
        }
        "21" {
            Write-Host "Instalando/Atualizando OpenJDK 21 e JRE 21 usando winget..."
            winget install --id EclipseAdoptium.Temurin.21.JDK -e --silent
            winget install --id EclipseAdoptium.Temurin.21.JRE -e --silent
        }
        default {
            Write-Host "Versão inválida selecionada. Saindo do script."
            exit
        }
    }
}

# Função principal
function MenuJava {
    
    
    # Verifica as versões do Java instaladas
    Check-JavaVersions

    # Loop do menu principal
    do {
        $choice = Show-Menu-Java

        switch ($choice) {
            "1" {
                Install-JDKandJRE "8"
            }
            "2" {
                Install-JDKandJRE "11"
            }
            "3" {
                Install-JDKandJRE "17"
            }
            "4" {
                Install-JDKandJRE "21"
            }
            "0" {
                Write-Host "Saindo..."
                exit
            }
            default {
                Write-Host "Escolha inválida, por favor tente novamente."
            }
        }
    } while ($true)
}

