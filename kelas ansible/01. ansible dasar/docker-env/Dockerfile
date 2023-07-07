FROM ubuntu:20.04

RUN apt update \
    && apt install -y openssh-server \
    openssh-client \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Enable PubkeyAuthentication and disable PermitEmptyPasswords
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config

RUN useradd -m -s /bin/bash belajaransible \
    && sudo usermod -aG sudo belajaransible

RUN mkdir -p /home/belajaransible/.ssh \
    && chmod 700 /home/belajaransible/.ssh

# SSH keys
COPY ansible.* /home/belajaransible/.ssh/

RUN eval $(ssh-agent -s) \
    && cat /home/belajaransible/.ssh/ansible.pub > /home/belajaransible/.ssh/authorized_keys \
    && chmod 600 /home/belajaransible/.ssh/authorized_keys \
    && chown -R belajaransible:belajaransible /home/belajaransible/

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]