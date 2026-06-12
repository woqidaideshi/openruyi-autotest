#!/bin/sh -eux
# Functional test: git - scalar

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 14: scalar ==="
rlRun 'which scalar' 0 "scalar available"
rlRun 'scalar --help 2>&1 | head -5' 0 "scalar help"


echo ""
echo "All git scalar tests passed!"
