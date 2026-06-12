#!/bin/sh -eux
# Functional test: make - Environment

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q make' 0 "Check make is installed"
rlRun 'which make' 0 "Check make command available"
rlRun 'which gmake' 0 "Check gmake command available"
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
