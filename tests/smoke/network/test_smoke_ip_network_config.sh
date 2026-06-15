#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ip addr show' 0 "ip addr 网络接口"
rlRun 'ip link show' 0 "ip link 链路层"
rlRun 'ip route show' 0 "ip route 路由表"
echo "smoke test passed!"
