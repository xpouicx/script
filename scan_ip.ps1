# On demande à l'utilisateur le réseau qu'il souhaite scanner
$range = Read-Host "Quel réseaux souhaitez-vous scanner ? (x.x.x.)" 
$Deb = Read-Host "De ?"
$Fin = Read-Host "à ?"

# On envoie un ping sur chaque adresse de la range à scanner et on affiche les ip et fqdn des machines qui répondent
$Deb..$Fin | ForEach-Object {
    Get-WmiObject Win32_PingStatus -Filter "Address='$range$_' and Timeout=1000 and ResolveAddressNames='true' and StatusCode=0" | select ProtocolAddress*
    }