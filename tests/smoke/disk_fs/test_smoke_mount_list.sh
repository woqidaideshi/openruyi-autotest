#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'mount | head -5' 0 "mount 挂载列表"
rlRun 'mount | grep " / "' 0 "mount 根分区挂载"
echo "smoke test passed!"
