# Script de création d'Utilisateur
 
#Déclaration des variables
$Domain = "infotech"  # Déclarez ici votre Domaine
$Ext = "local"  # Déclarez ici l'extension (com, info, lan, local....)
$Server ="adserver.infotech.local"  # Déclarez ici le serveur d'exécution
$FQDN ="@infotech.local"  # Déclarez ici le nom du Domaine précédé de "@" cela servira pour la création du UserPrincipalName
$LogFolder = "C:\Log" # Déclarez ici l'emplacement du répertoire de Log
$Folder = "Log" # Déclarez ici le nom du répertoire de Log
$LogFile = "C:\Log\LogScript.txt" # Déclarez ici l'emplacement du fichiers de Log du script
$File = "LogScript.txt" # Déclarez ici le nom du fichier de Log du script
$LogError = "C:\Log\LogError.txt" # Déclarez ici l'emplacement du fichier d'erreur global
$LogCatch = "C:\Log\LogCatch.txt" # Déclarez ici l'emplacement du fichier de gestion de l'erreur
$FileCatch = "LogCatch.txt" # Déclarez ici le nom du fichier de gestion de l'erreur
$CSV = "C:\Users4.csv" # Déclarez ici le chemin d'accès à votre fichier csv
 
 
# Avant de commencer nous allons créer un répertoire et un fichier pour les logs
 
 
if (!(Test-Path $logfolder)) {
 
    New-Item -Name $Folder -Path C:\ -type directory
    New-Item -Name $File -Path $LogFolder -type file
    New-Item -Name $FileCatch -Path $LogFolder -type file
    Write-Output "Le dossier $Folder n'existait pas, création du Dossier $Folder, du fichier $File et $FileCatch" | Add-Content $LogFile
                                }
Else {
    Write-Output "Le dossier $Folder existe déjà!" | Add-Content $LogFile
        }
 
# Import du module Active Directory et import du fichier csv
 
Import-Module ActiveDirectory
 
Import-Csv -Delimiter ";" -Path $CSV | ForEach-Object {
    $OU =$_."OrganizationalUnit"
 
    # Test de la présence de l'unité d'organisation et création si elle n'existe pas
 
    if ((Get-ADOrganizationalUnit -Filter {SamAccountName -eq $OU}) -eq $null) {
        Write-Output "l'unité d'organisation $OU n'existe pas, création de la nouvelle Unité d'organisation" | Add-Content $LogFile
        Try {
            New-ADOrganizationalUnit -SamAccountName $OU -Path "DC=$Domain,DC=$Ext" -ErrorAction Stop -ErrorVariable eOU
                }
        Catch{
            "Une erreur $eOU a eu lieu à $((Get-Date).DateTime)"  | Add-Content $LogCatch
                }
        Finally{
            "Fin de l'opération Ajout d'une OU"
                }
                                                                        }
    Else {
        Write-Output "l'unité d'organisation $OU existe déjà" | Add-Content $LogFile
            }
    $User =$_."SamAccountName"
    $DisplayName =$_."DisplayName"
    $GivenName =$_."GivenName"
    $Name =$_."Name"
    $SamAccountName =$_."SamAccountName"
    $Surname =$_."Surname"
    $Description =$_."Description"
    $Company = $_."Company"
    $Department = $_."Department"
    $EmailAddress =$_."EmailAdress"
    $OfficePhone  =$_."OfficePhone"
 
    # Test de la présence de l'utilisateur et création si il n'existe pas
 
    if ((Get-ADUser -Filter {SamAccountName -eq $User}) -eq $null) {
        Write-Output "l'utilisateur $User n'existe pas, création du nouvel utilisateur" | Add-Content $LogFile
        Try {
            New-ADUser -Company:$Company -Department:$Department -DisplayName:$DisplayName -GivenName:$GivenName -Name:$Name -Description:$Description -EmailAddress:$EmailAddress -OfficePhone:$OfficePhone -Title:$Title -Path:"OU=$OU,DC=$Domain,DC=$Ext" -SamAccountName:$SamAccountName -Server:"$Server" -Surname:$Surname -Type:"user" -UserPrincipalName:"$SamAccountName$FQDN"  -AccountPassword:(ConvertTo-SecureString -AsPlainText "T$$r2019ninja" -Force) -Enabled:$true -AccountNotDelegated:$false -AllowReversiblePasswordEncryption:$false -CannotChangePassword:$false -PasswordNeverExpires:$false -ChangePasswordAtLogon:$true -ErrorAction Stop -ErrorVariable eUser
                }
    Catch{
        "L'erreur $eUser s'est produite à $((Get-Date).DateTime)" | Add-Content $LogCatch
            }
    Finally{
        "Fin de l'opération Ajout d'un Utilisateur"
            }
                                                                        }
    Else {
        Write-Output "l'utilisateur existe déjà" | Add-Content $LogFile
            }
                                                                                                                    }
 
# Récupérations des erreurs
 
$Error > $LogError