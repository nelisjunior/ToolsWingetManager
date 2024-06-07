# Importa as funções do arquivo InstallWinGet.ps1
. ".\InstallWinget.ps1"

# Importa as funções Java
. ".\ManagerJava.ps1"


# Função para exibir o menu e capturar a escolha do usuário
function Show-Menu {
    param (
        [string]$Title = 'Gerenciador Winget e Java'
    )

    Write-Host "============================="
    Write-Host " $Title"
    Write-Host "============================="
    Write-Host "1. Instalar/Atualizar o Java"
    Write-Host "2. Instalar/Atualizar o Winget"
    Write-Host "0. Sair"
    Write-Host "============================="
    $choice = Read-Host "Digite o número da sua escolha"
    return $choice
}



function Main{
	
   # Loop do menu principal
    do {
        $choice = Show-Menu

        switch ($choice) {
            "1" {
                MenuJava "Java"
            }
            "2" {
                MenuWinget "Winget"
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

# Chama a função principal
Main
