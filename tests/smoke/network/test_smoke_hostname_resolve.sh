#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'getent hosts localhost' 0 "getent 解析 localhost"
rlRun 'cat /etc/resolv.conf' 0 "/etc/resolv.conf DNS配置"
rlRun 'cat /etc/hosts' 0 "/etc/hosts 本地解析"
echo "smoke test passed!"
