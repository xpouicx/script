#!/bin/bash

# On spécifie l'emplacement des fichiers à supprimer 
read -p "Selectionner l'emplacement des fichiers à supprmier : " Path
# On spécifie l'extension des fichiers à supprimer
read -p "Selectionner l'extension des fichiers : " Ext
# On spécifie l'ancienneté des fichiers à supprimer
read -p "Selectionner l'ancienneté des fichiers à supprimer : " Time

# On supprime les fichiers selon les variables définit ci-dessus
find $Path -name "*.$Ext" -type f -mtime +$Time -exec rm -f {} \;
