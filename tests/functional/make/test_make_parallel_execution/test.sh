#!/bin/sh -eux
# Functional test: make - Parallel-execution

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q make' 0 "Check make is installed"
rlRun 'which make' 0 "Check make command available"
rlRun 'which gmake' 0 "Check gmake command available"
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Parallel execution ==="
cat > Makefile << 'EOF'
.PHONY: all
all: t1 t2 t3
t1 t2 t3:
	@echo "Building $@"
EOF
rlRun 'make -j2' 0 "make -j2: parallel 2 jobs"


echo ""
echo "All make Parallel-execution tests passed!"
