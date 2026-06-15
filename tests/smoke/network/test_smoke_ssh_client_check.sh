#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ssh -V 2>&1' 0 "ssh 版本"
rlRun 'which scp' 0 "scp 存在"
rlRun 'which sftp' 0 "sftp 存在"
echo "smoke test passed!"
