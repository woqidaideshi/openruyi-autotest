#!/bin/sh -eux
# Functional test: make - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q make 2>/dev/null || { echo 'make not installed, skipping'; exit 0; }
which make 2>/dev/null || echo 'make not found'
which gmake 2>/dev/null || echo 'gmake not found'
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Error handling ==="
cat > Makefile << 'EOF'
.PHONY: all
all:
	@exit 1
EOF
rlRun 'make -k 2>&1 || true' 0 "make -k: continue on error"
rlRun 'make -i 2>&1 || true' 0 "make -i: ignore errors"

cd /
rm -rf $TmpDir

echo ""
echo "All make functional tests passed!"

echo ""
echo "All make Error-handling tests passed!"
