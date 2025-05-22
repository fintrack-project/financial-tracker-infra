#!/bin/bash
chmod 666 /var/run/docker.sock
su jenkins -c "/usr/bin/tini -- /usr/local/bin/jenkins.sh" 