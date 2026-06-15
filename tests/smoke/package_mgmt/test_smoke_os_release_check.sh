#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'cat /etc/os-release' 0 "/etc/os-release 存在"
rlRun 'grep openRuyi /etc/os-release' 0 "openRuyi 发行版确认"
rlRun 'rpm -q openruyi-release' 0 "openruyi-release 包存在"
echo "smoke test passed!"
