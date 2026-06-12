#!/bin/sh -eux
# Functional test: make - Options

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q make 2>/dev/null || { echo 'make not installed, skipping'; exit 0; }
which make 2>/dev/null || echo 'make not found'
which gmake 2>/dev/null || echo 'gmake not found'
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Options ==="
cat > Makefile << 'EOF'
.PHONY: all
all:
	@echo "target"
EOF
rlRun 'make -n' 0 "make -n: dry run"
rlRun 'make -B' 0 "make -B: always make"
rlRun 'make --just-print' 0 "make --just-print"
rlRun 'make -d 2>&1 | head -5' 0 "make -d: debug output"
rlRun 'make --debug=b 2>&1 | head -5' 0 "make --debug=b: basic debug"
rlRun 'make -q' 0 "make -q: question mode"
rlRun 'make -s' 0 "make -s: silent"


echo ""
echo "All make Options tests passed!"
