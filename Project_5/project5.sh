#!/bin/bash
# Setup
sudo groupadd devs
sudo useradd -m -G devs alice
sudo useradd -m bob
sudo mkdir /srv/project
sudo chown root:devs /srv/project
sudo chmod 770 /srv/project
id alice; id bob; ls -ld /srv/project

# Tests
cd /
sudo -u alice touch /srv/project/alice.txt && echo "alice: write OK"
sudo -u alice ls /srv/project && echo "alice: read OK"
sudo -u bob ls /srv/project || echo "bob: denied"
sudo -u bob touch /srv/project/bob.txt || echo "bob: denied"
