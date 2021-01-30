# terraform
This repository is created for the purpose of mastering terraform and AWS. It defines a personal AWS infrastructure.

Technology used is terraform (@see: https://www.terraform.io/)

# Installation
## Git
Nous utilisons les submodules git.
```
git submodule init
git submodule update
```
## Terraform
_https://www.terraform.io/downloads.html_

Place the binary in your $ PATH.

Example script for Linux :
```
# pre requisites
sudo apt-get install jq unzip

# terraform
TF_VERSION=0.12.12
curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip terraform_${TF_VERSION}_linux_amd64.zip
chmod +x terraform
sudo mv terraform /usr/local/bin/terraform_${TF_VERSION}
sudo rm /usr/local/bin/terraform
sudo ln -s /usr/local/bin/terraform_${TF_VERSION} /usr/local/bin/terraform
rm terraform_${TF_VERSION}_linux_amd64.zip
```

# Paramétrage du client terraform
First time you want to create a state file, run :
/!\ Run once only, if state already init, you can be doing really big cheat
```
export AWS_ACCESS_KEY_ID=YOUR_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
export AWS_REGION=eu-west-1

terraform init
```

Next, to apply changes :
```
terraform plan -out /tmp/.tmpstate
terraform apply /tmp/.tmpstate
```

# Modifier le state local
Pour enlever un objet au state de terraform, et ainsi laisser l'objet en état sur AWS :
```
terraform state rm object_id
```

# Fonctions utilitaires
A sourcer depuis le .bashrc
```
function get_tf_objects() {
   sed -n -re '/\s*^(resource|module)/p' $1 | sed -re '/resource/s/.*\"(.*)\".*\"(.*)\".*/--target=\1.\2/' -re '/module/s/module\s+\"(.*)\".*/--target=module.\1/' | tr '\n' ' '
}

export -f get_tf_objects

function get_tf_objects_raw() {
   sed -n -re '/\s*^(resource|module)/p' $1 | sed -re '/resource/s/.*\"(.*)\".*\"(.*)\".*/\1.\2/' -re '/module/s/module\s+\"(.*)\".*/module.\1/'
}

export -f get_tf_objects_raw

function get_tf_objects_id_mapping() {
	 extra_pattern="$1"
   for obj in `terraform state list | grep -v data | grep "$extra_pattern"`; do terraform state show $obj | sed -n 's#^\(.*id.*\)= "\(.*\)"#\1\t'$obj'\t\2#p'; done;
}

export -f get_tf_objects_id_mapping
```
