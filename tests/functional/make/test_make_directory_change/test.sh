#!/bin/sh -eux
# Functional test: make - Directory-change

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q make 2>/dev/null || { echo 'make not installed, skipping'; exit 0; }
which make 2>/dev/null || echo 'make not found'
which gmake 2>/dev/null || echo 'gmake not found'
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
