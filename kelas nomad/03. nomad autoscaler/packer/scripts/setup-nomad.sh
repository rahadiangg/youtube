#!/bin/bash
export ARCH=$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)

sudo apt update && sudo apt install -y unzip

curl -L -o nomad.zip "https://releases.hashicorp.com/nomad/1.8.3/nomad_1.8.3_linux_${ARCH}.zip"
unzip nomad
sudo mv nomad /usr/bin/nomad

rm nomad* LICENSE.txt

# install CNI plugins
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-${ARCH}"-v1.5.0.tgz && \
  sudo mkdir -p /opt/cni/bin && \
  sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz

rm cni-plugins.tgz

# enable linux bridge module
# sudo sh -c "cat >> /etc/modules" <<-EOF
# br_netfilter
# bridge
# EOF

sudo sh -c "cat >> /etc/sysctl.d/bridge.conf" <<-EOF
net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
