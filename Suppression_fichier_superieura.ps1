#L'utilisateur doit spécifier le chemin d'accès du dossier
$Path=Read-Host "Quel est le chemin d'accès du dossier" 

#L'utilisateur doit spécifier l'extension des fichiers à supprimer
$Ext=Read-Host "Quel type de fichier voulez-vous supprimer ?" 

#On définit le nombre de jour à partir duquel le fichier est supprimer
$Daysback = "-365" 

#Le script récupère la date du jour
$CurrentDate = Get-Date 

#Le script calcul à partir de quel date les fichiers devront être supprimer 
$DatetoDelete = $CurrentDate.AddDays($Daysback) 

#On récupère les logs des fichiers supprimés
Get-ChildItem $Path *.$ext | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Out-File C:\Users\TSSR\Desktop\log.txt 

#On supprime les fichiers 
Get-ChildItem $Path *.$ext | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item 