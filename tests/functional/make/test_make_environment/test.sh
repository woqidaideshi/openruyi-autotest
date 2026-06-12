#!/bin/sh -eux
# Functional test: make - Environment

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q make 2>/dev/null || { echo 'make not installed, skipping'; exit 0; }
which make 2>/dev/null || echo 'make not found'
which gmake 2>/dev/null || echo 'gmake not found'
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Environment ==="
export TESTENV=hello
cat > Makefile << 'EOF'
.PHONY: all
all:
	@echo $(TESTENV)
EOF
rlRun 'make -e | grep hello' 0 "make -e: environment overrides"
rlRun 'make | grep hello' 0 "Environment variable in make"


echo ""
echo "All make Environment tests passed!"
