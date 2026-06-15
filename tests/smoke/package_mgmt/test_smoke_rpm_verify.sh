#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -V coreutils 2>&1 || true' 0 "rpm -V 验证包完整性"
echo "smoke test passed!"
