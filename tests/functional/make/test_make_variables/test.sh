#!/bin/sh -eux
# Functional test: make - Variables

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q make 2>/dev/null || { echo 'make not installed, skipping'; exit 0; }
which make 2>/dev/null || echo 'make not found'
which gmake 2>/dev/null || echo 'gmake not found'
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
