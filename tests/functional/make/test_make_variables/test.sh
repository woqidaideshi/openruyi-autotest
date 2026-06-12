#!/bin/sh -eux
# Functional test: make - Variables

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q make' 0 "Check make is installed"
rlRun 'which make' 0 "Check make command available"
rlRun 'which gmake' 0 "Check gmake command available"
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Variables ==="
cat > Makefile << 'EOF'
VAR = test_value
.PHONY: all
all:
	@echo $(VAR)
EOF
rlRun 'make' 0 "Variable expansion"
rlRun 'make VAR=override | grep override' 0 "Override variable"


echo ""
echo "All make Variables tests passed!"
