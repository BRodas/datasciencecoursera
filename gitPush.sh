echo "Escribe el mensaje correspondiente al commit"
read mensaje

sudo git add -A
sudo git commit -m "$mensaje"
sudo git push -u origin --all
