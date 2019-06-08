#!/bin/bash
PROXYIP=11.0.0.1
echo $PROXYIP
echo "proxy=http://$PROXYIP:3128"  » /etc/yum.conf
#proxy_username=test
#proxy_password=test
#echo "Acquire::http::Proxy "http://$PROXYIP:3128";" » /etc/apt/apt.conf
echo "export http_proxy="http://$PROXYIP:3128/"" » /etc/profile
echo "export https_proxy="http://$PROXYIP:3128/"" » /etc/profile
echo "export ftp_proxy="http://$PROXYIP:3128/" "  » /etc/profile
source /etc/profile

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi
case $(uname -m) in
x86_64)
    BITS=64
    ;;
i*86)
    BITS=32
    ;;
*)
    BITS=?
    ;;
esac
Or change ARCH to be the more common, yet unambiguous versions: x86 and x64 or similar:

case $(uname -m) in
x86_64)
    ARCH=x64  # or AMD64 or Intel64 or whatever
    ;;
i*86)
    ARCH=x86  # or IA32 or Intel32 or whatever
    ;;
*)
    # leave ARCH as-is
    ;;
esac