#!/bin/bash
# https://docs.vagrantup.com/v2/provisioning/shell.html

source "/vagrant/scripts/common.sh"

function setupHosts {
	echo "modifying /etc/hosts file"
        echo "127.0.0.1 node1" >> /etc/nhosts
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/nhosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/nhosts
	cp /etc/nhosts /etc/hosts
	rm -f /etc/nhosts
}

function setupAptsource {
	echo "***********modifying apt source to tsinghua"
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse"  > /etc/apt/sources.list
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse"   >> /etc/apt/sources.list
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse"   >> /etc/apt/sources.list
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse"   >> /etc/apt/sources.list
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse"   >> /etc/apt/sources.list
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse"   >> /etc/apt/sources.list
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse"   >> /etc/apt/sources.list
	echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse"  >> /etc/apt/sources.list
	apt-get update
}


function setupSwap {
    # setup swapspace daemon to allow more memory usage.
    apt-get install -y swapspace
}


function installSSHPass {
	apt-get update
	apt-get install -y sshpass
}

function overwriteSSHCopyId {
	cp -f $RES_SSH_COPYID_MODIFIED /usr/bin/ssh-copy-id
}

function createSSHKey {
	echo "generating ssh key"
	ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	cp -f $RES_SSH_CONFIG ~/.ssh
}

function setupUtilities {
    # so the `locate` command works
    apt-get install -y mlocate
    updatedb
    apt-get install -y ant
    apt-get install -y unzip
    apt-get install -y python-minimal
    apt-get install -y curl apt-utils
}

echo "setup ubuntu"

echo "setup hosts file"
setupHosts

echo "setup apt source"
setupAptsource


echo "setup ssh"
installSSHPass
createSSHKey
overwriteSSHCopyId

echo "setup utilities"
setupUtilities

echo "setup swap daemon"
setupSwap

echo "ubuntu setup complete"
