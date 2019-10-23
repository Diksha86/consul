sudo -i
yum -y install go
yum -y install git
mkdir -p $GOPATH/src/github.com/hashicorp
cd !$
git clone https://github.com/hashicorp/consul.git
cd consul
make tools
make dev
cd $GOPATH/src/github.com/hashicorp
cd consul
cd bin
