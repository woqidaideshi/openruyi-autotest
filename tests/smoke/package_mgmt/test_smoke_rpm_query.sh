#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm --version' 0 "rpm 版本"
rlRun 'rpm -q coreutils' 0 "rpm -q 查询包"
rlRun 'rpm -qa | head -5' 0 "rpm -qa 列出所有包"
rlRun 'rpm -qi coreutils | head -5' 0 "rpm -qi 包信息"
echo "smoke test passed!"
