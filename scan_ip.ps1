# On demande � l'utilisateur le r�seau qu'il souhaite scanner
$range = Read-Host "Quel r�seaux souhaitez-vous scanner ? (x.x.x.)" 
$Deb = Read-Host "De ?"
$Fin = Read-Host "� ?"

# On envoie un ping sur chaque adresse de la range � scanner et on affiche les ip et fqdn des machines qui r�pondent
$Deb..$Fin | ForEach-Object {
    Get-WmiObject Win32_PingStatus -Filter "Address='$range$_' and Timeout=1000 and ResolveAddressNames='true' and StatusCode=0" | select ProtocolAddress*
    }