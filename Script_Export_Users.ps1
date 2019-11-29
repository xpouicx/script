#Extraire liste des utilisateur de l'OU
Import-Module ActiveDirectory
Get-ADUser -Filter * -SearchBase "OU=ComptesStaff,OU=TSSR,DC=batac,DC=lan" -Properties GivenName, Surname, UserPrincipalName, SamAccountName, Description, DisplayName | Select-Object GivenName, Surname, UserPrincipalName, SamAccountName, Description, DisplayName | Export-CSV C:\Users.csv