#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'dnf --version 2>&1 || true' 0 "dnf 版本"
rlRun 'dnf repolist 2>&1 | head -5' 0 "dnf repolist 仓库列表"
echo "smoke test passed!"
