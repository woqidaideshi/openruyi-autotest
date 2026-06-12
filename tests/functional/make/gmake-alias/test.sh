#!/bin/sh -eux
# Functional test: make - gmake-alias

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q make' 0 "Check make is installed"
rlRun 'which make' 0 "Check make command available"
rlRun 'which gmake' 0 "Check gmake command available"
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: gmake alias ==="
rlRun 'gmake --version 2>&1 | grep "GNU Make"' 0 "gmake is GNU Make"


echo ""
echo "All make gmake-alias tests passed!"
