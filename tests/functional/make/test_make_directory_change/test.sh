#!/bin/sh -eux
# Functional test: make - Directory-change

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q make' 0 "Check make is installed"
rlRun 'which make' 0 "Check make command available"
rlRun 'which gmake' 0 "Check gmake command available"
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Directory change ==="
mkdir subdir
cat > subdir/Makefile << 'EOF'
.PHONY: all
all:
	@echo "subdir_make"
EOF
rlRun 'make -C subdir' 0 "make -C: change directory"


echo ""
echo "All make Directory-change tests passed!"
