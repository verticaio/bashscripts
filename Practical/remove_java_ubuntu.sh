#!/bin/bash
#Remove completely Java on Ubuntu 16.04
update-alternatives --remove-all java
update-alternatives --remove-all javac
update-alternatives --remove-all javaws
rm -rf /usr/lib/jvm/jdk1.8.0
dpkg -l | grep jdk
dpkg -l | grep jre
dpkg -l | grep java
apt-get purge --java-packages
