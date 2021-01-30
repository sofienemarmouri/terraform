#!/bin/bash
sudo apt-get update
sudo apt-get -y upgrade

echo "Install Java JDK 8"
yum remove -y java
sudo apt-get -y install openjdk-8-jdk

echo "Install Maven"
sudo apt update
sudo apt -y install maven

echo "Install git"
sudo apt -y install git
sudo apt update
sudo apt upgrade

echo "Install packages to allow apt to use a repository over HTTPS"
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

echo "Add Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
#apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
#curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "Verify the key with the fingerprint"
sudo apt-key fingerprint 0EBFCD88

echo "set up the stable repository"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

echo "install the latest version of Docker Engine and containerd"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
#apt-cache madison docker-ce

echo " Install a specific version"
sudo apt-get install docker-ce=5:19.03.14~3-0~debian-stretch docker-ce-cli=https://download.docker.com/linux/debian stretch/stable amd64 Packages containerd.io

echo "Change some settings on All Nodes for System requirements"
sudo swapoff -a
update-alternatives --config iptables

echo "restart docker"
sudo systemctl restart docker

#Install Kubeadm on All Nodes
echo "Install Kubeadm on All Nodes"
sudo apt -y install apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

echo "Install kubeadm kubelet kubectl"
sudo apt update
sudo apt -y install kubeadm kubelet kubectl
sudo systemctl enable kubelet

echo "Initialization kubeadm"
sudo kubeadm init

echo "copy the config file with the secrets and connection information for the cluster"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Finally, connect to the new Kubernetes cluster to install a CNI"
kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml