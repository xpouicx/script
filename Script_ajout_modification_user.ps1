#====================================================================================================================================================
# Script d'importation du Fichier CSV ERP vers Active Directory
# Création et Modification des comptes étudiants
# Script conçu par Johan PITTONI - ICP
# Version : 1.0
# Date de conception : le 28 mai 2018
#====================================================================================================================================================


#====================================================================================================================================================
# 0. Initialisation
#====================================================================================================================================================
#Récupération du fichier de logs
$Date = Get-Date
$Fichier = "C:\Scripts-PS-AD\Logs" + $Date.Day.ToString() + "-" + $Date.Month.ToString() + "-" + $Date.Year.ToString() + ".txt"
#Import du module Active Directory
$Import = Import-Module ActiveDirectory
#Début des logs
Add-Content $Fichier ($Date.ToString() + ";Notification;" + "Lancement de la synchronisation CSV - Active Directory")
#____________________________________________________________________________________________________________________________________________________


#====================================================================================================================================================
# 1. Création des comptes dans Active Directory
#====================================================================================================================================================
Add-Content $Fichier ($Date.ToString() + ";Notification;" + "Etape 1 : Lancement de la récupération des comptes à créer dans Active Directory")
$csv = Import-Csv -Delimiter ";" -Path "C:\users.csv"
$Chemin = "OU=ComptesStaff,OU=TSSR,DC=batac,DC=lan"
$UtilisateursACreer = @()
foreach ($Utilisateur in $csv) {
    if ($Utilisateur.Action -eq 'Add') {
    $UtilisateursACreer += $Utilisateur.SamAccountName

		#Création des nouveaux utilisateurs dans Active Directory
		$creation = New-ADUser -SamAccountName $Utilisateur.SamAccountName -EmailAddress $Utilisateur.UserPrincipalName -accountpassword (ConvertTo-SecureString $Utilisateur.password -AsPlainText -force) -PasswordNeverExpires $true -CannotChangePassword $false -UserPrincipalName $Utilisateur.UserPrincipalName  -DisplayName $Utilisateur.DisplayName -GivenName $Utilisateur.GivenName -Surname $Utilisateur.SurName -description $Utilisateur.description -Name $Utilisateur.DisplayName -OfficePhone $Utilisateur.OfficePhone -Enabled $true -Path $Chemin
		#sleep (30)
		#Modification des extensionAttributes Active Directory du compte utilisateur (ADSI)
		$DN = (Get-ADUser -Identity $Utilisateur.SamAccountName -Properties DistinguishedName).DistinguishedName
		$User = [ADSI]"LDAP://$DN"
		If ($Utilisateur.extensionAttribute1 -ne "")
		{
		    $User.put("extensionAttribute1",$Utilisateur.OfficePhone)
		}
		#If ($Utilisateur.extensionAttribute2 -ne "")
		#{
		#$User.put("extensionAttribute2",$Utilisateur.extensionAttribute2)
		#Write-Host "OK pour le 2"
		#}
		#If ($Utilisateur.extensionAttribute3 -ne "")	
		#{
		#$User.put("extensionAttribute3",$Utilisateur.extensionAttribute3)
		#}
		#If ($Utilisateur.extensionAttribute4 -ne "")
		#{
		#$User.put("extensionAttribute4",$Utilisateur.extensionAttribute4)
		#}
		#If ($Utilisateur.extensionAttribute5 -ne "")
		#{
		#$User.put("extensionAttribute5",$Utilisateur.extensionAttribute5)
		#}
		#If ($Utilisateur.extensionAttribute6 -ne "")
		#{
		#$User.put("extensionAttribute6",$Utilisateur.extensionAttribute6)
		#}
		#If ($Utilisateur.extensionAttribute7 -ne "")
		#{
		#$User.put("extensionAttribute7",$Utilisateur.Title)
		#}
		#If ($Utilisateur.extensionAttribute8 -ne "")
		#{
		#$User.put("extensionAttribute8",$Utilisateur.extensionAttribute8)
		#}
		#If ($Utilisateur.extensionAttribute9 -ne "")
		#{
		#$User.put("extensionAttribute9",$Utilisateur.extensionAttribute9)
		#}
		#If ($Utilisateur.extensionAttribute10 -ne "")
		#{
		#$User.put("extensionAttribute10",$Utilisateur.extensionAttribute10)
		#}
		#If ($Utilisateur.extensionAttribute11 -ne "")
		#{
		#$User.put("extensionAttribute11",$Utilisateur.extensionAttribute11)
		#}
		#If ($Utilisateur.extensionAttribute12 -ne "")
		#{
		#$User.put("extensionAttribute12",$Utilisateur.extensionAttribute12)
		#}
		#If ($Utilisateur.extensionAttribute14 -ne "")
		#{
		#$User.put("extensionAttribute14",$Utilisateur.extensionAttribute14)
		#}
		If ($Utilisateur.extensionAttribute15 -ne "")
		{
		$User.put("extensionAttribute15",$Utilisateur.password)
		$User.SetInfo()
		}
		$test1 = $Error.Count
		$verification = Get-ADUser -Identity $Utilisateur.SamAccountName
		$test2 = $Error.Count
		#Vérification que le compte a bien été créé
		if ($test1 -ne $test2) {Add-Content $Fichier ($Date.ToString() + ";Erreur;" + "Le compte " + $Utilisateur.SamAccountName + " n'a pas été créé dans Active Directory") }
		else { Write-Host ("Le compte " + $Utilisateur.SamAccountName + " a été créé dans Active Directory") }
		}
	}
    #}
Add-Content $Fichier ($Date.ToString() + ";Notification;" + "Il y a " + $UtilisateursACreer.Count + " comptes créés dans l'Active Directory")
#____________________________________________________________________________________________________________________________________________________


#====================================================================================================================================================
# 2. Modification des comptes dans l'annuaire Active Directory
#====================================================================================================================================================
Add-Content $Fichier ($Date.ToString() + ";Notification;" + "Etape 2 : Lancement de la modification des comptes dans Active Directory")
$csv = Import-CSV -Path "C:\users.csv" -Delimiter ";"
$UtilisateursAModifier = @()
foreach ($Utilisateur in $csv) {
	$UtilisateursAModifier += $Utilisateur.SamAccountName
	if ($Utilisateur.Action -eq "Update") {
		#Vérification que le compte existe
		$test1 = $Error.Count
		$verification = Get-ADUser -Identity $Utilisateur.SamAccountName -ErrorAction SilentlyContinue
		$test2 = $Error.Count
		if ($test1 -ne $test2) {
			Add-Content $Fichier ($Date.ToString() + ";Notification;" + "Le compte à modifier " + $Utilisateur.SamAccountName + " n'existe pas dans Active Directory")
		}
		else {
			#Modification des attributs du compte (Set-ADUser)
			$modification = Set-ADUser -Identity $Utilisateur.SamAccountName -Description $Utilisateur.description -UserPrincipalName $Utilisateur.UserPrincipalName -EmailAddress $Utilisateur.UserPrincipalName -OfficePhone $Utilisateur.OfficePhone 
			#$modificationpassword = Set-ADAccountPassword -Identity $Utilisateur.SamAccountName -NewPassword (ConvertTo-SecureString $Utilisateur.Password -AsPlainText -force)
			#Modification des extentionAttributes Active Directory du compte utilisateur (ADSI)
			#$DN = (Get-ADUser -Identity $Utilisateur.SamAccountName -Properties DistinguishedName).DistinguishedName
			#$User = [ADSI]"LDAP://$DN"

		#If ($Utilisateur.extensionAttribute1 -ne "")
		#{
		#$User.put("extensionAttribute1",$Utilisateur.password)
		#}
		
		#If ($Utilisateur.extensionAttribute2 -ne "")
		#{
		#$User.put("extensionAttribute2",$Utilisateur.extensionAttribute2)
		#}

		#If ($Utilisateur.extensionAttribute3 -ne "")	
		#{
		#$User.put("extensionAttribute3",$Utilisateur.extensionAttribute3)
		#}

		#If ($Utilisateur.extensionAttribute4 -ne "")
		#{
		#$User.put("extensionAttribute4",$Utilisateur.extensionAttribute4)
		#}

		#If ($Utilisateur.extensionAttribute5 -ne "")
		#{
		#$User.put("extensionAttribute5",$Utilisateur.extensionAttribute5)
		#}

		#If ($Utilisateur.extensionAttribute6 -ne "")
		#{
		#$User.put("extensionAttribute6",$Utilisateur.extensionAttribute6)
		#}

		#If ($Utilisateur.extensionAttribute7 -ne "")
		#{
		#$User.put("extensionAttribute7",$Utilisateur.extensionAttribute7)
		#}

		#If ($Utilisateur.extensionAttribute8 -ne "")
		#{
		#$User.put("extensionAttribute8",$Utilisateur.extensionAttribute8)
		#}

		#If ($Utilisateur.extensionAttribute9 -ne "")
		#{
		#$User.put("extensionAttribute9",$Utilisateur.extensionAttribute9)
		#}

		#If ($Utilisateur.extensionAttribute10 -ne "")
		#{
		#$User.put("extensionAttribute10",$Utilisateur.extensionAttribute10)
		#}

		#If ($Utilisateur.extensionAttribute11 -ne "")
		#{
		#$User.put("extensionAttribute11",$Utilisateur.extensionAttribute11)
		#}

		#If ($Utilisateur.extensionAttribute12 -ne "")
		#{
		#$User.put("extensionAttribute12",$Utilisateur.extensionAttribute12)
		#}

		#If ($Utilisateur.extensionAttribute13 -ne "")
		#{
		#$User.put("extensionAttribute13",$Utilisateur.extensionAttribute13)
		#}

		#If ($Utilisateur.extensionAttribute14 -ne "")
		#{
		#$User.put("extensionAttribute14",$Utilisateur.extensionAttribute14)
		#}

		#If ($Utilisateur.extensionAttribute15 -ne "")
		#{
		#$User.put("extensionAttribute15",$Utilisateur.extensionAttribute15)
		#}
		#$User.SetInfo()
		Write-Host ("Compte " + $Utilisateur.SamAccountName + " modifié")
		}
    	}
}
Add-Content $Fichier ($Date.ToString() + ";Notification;" + "Il y a " + $UtilisateursAModifier.Count + " comptes modifiés dans l'Active Directory")
#____________________________________________________________________________________________________________________________________________________


#====================================================================================================================================================
# Finalisation de la synchronisation
#====================================================================================================================================================
#Fin des logs
Add-Content $Fichier ($Date.ToString() + ";Notification;" + "Fin de la synchronisation du fichier CSV vers Active Directory")
