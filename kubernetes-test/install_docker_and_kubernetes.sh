#!/bin/bash
sudo yum update -y

#Installez le package de moteur Docker le plus récent.
sudo amazon-linux-extras install docker

#Lancez le service Docker
sudo service docker start

#Ajoutez ec2-user au groupe docker afin de pouvoir exécuter les commandes Docker sans utiliser sudo
sudo usermod -a -G docker ec2-user

#Installer kubectl sous Linux
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl

#Appliquez les autorisations d'exécution au fichier binaire
chmod +x ./kubectl

#Copiez le fichier binaire dans un dossier de votre PATH.

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=/home/:$HOME/bin
#mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin