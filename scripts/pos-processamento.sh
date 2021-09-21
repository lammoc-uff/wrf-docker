#!/bin/bash

################# INSTALAÇÃO DO GrADs ##############

# Download do GrADS e descompactação
echo "Baixando GrADS.."
cd "$PARENTPATH/paralelo"
wget "ftp://cola.gmu.edu/grads/2.0/grads-2.0.2-bin-CentOS5.8-x86_64.tar.gz"
tar -zxvf grads-2.0.2-bin-CentOS5.8-x86_64.tar.gz
rm grads-2.0.2-bin-CentOS5.8-x86_64.tar.gz

# InstalaÇÃo do GrADS
export PATH="/opt/grads-2.0.2/bin/grads"
cd "$PARENTPATH/paralelo"
mv grads-2.0.2 /opt/
cd
sed -i "10i export path=/opt/grads-2.0.2/bin:$path" .bashrc

#PATH=$PATH:/opt/opengrads