#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q --scripts bash 2>&1 | head -5' 0 "rpm 脚本内容"
rlRun 'rpm -ql bash | head -5' 0 "rpm -ql 文件列表"
echo "smoke test passed!"
