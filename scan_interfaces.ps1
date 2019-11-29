# Stratégie d'exécution en mode Bypass pour la session uniquement
Set-ExecutionPolicy Bypass -Scope Process 

# Importation du module NetAdapter
Import-Module NetAdapter 

# Définition des variables
$user = $Env:USERNAME
$path = "C:\Users\$user\Desktop\Log"
$date = Get-Date -Format "dd_MM_yyyy-HH_mm"
$file = "$path\IPconfig-$user-$date.txt"

# Création du dossier log sur le bureau 
if (-not (Test-Path "$path")) { New-Item -Path "$path" -ItemType Directory > $null }

# Création du fichier
Write-Output "Configuration IP :" >> $file

# Obtention de la configuration IP et écriture à la suite du fichier
Get-NetIPConfiguration >> $file 

Write-Output "Interfaces" >> $file

# Obtention des caractéristiques de IFs et écriture à la fin du fichier
Get-NetAdapter | fl Name, InterfaceDescription, MacAddress, Status,  LinkSpeed >> $file 
