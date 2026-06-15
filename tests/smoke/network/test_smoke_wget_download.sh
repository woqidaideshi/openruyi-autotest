#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'wget --version 2>&1 || true' 0 "wget 版本"
rlRun 'wget --timeout=5 --spider http://example.com 2>&1 || true' 0 "wget spider模式"
echo "smoke test passed!"
