#!/bin/sh -eux
# Functional test: make - Basic-Makefile-execution

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q make 2>/dev/null || { echo 'make not installed, skipping'; exit 0; }
which make 2>/dev/null || echo 'make not found'
which gmake 2>/dev/null || echo 'gmake not found'
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic Makefile execution ==="
cat > Makefile << 'EOF'
.PHONY: all hello clean
all: hello
hello:
	@echo "Hello Make"
clean:
	rm -f hello
EOF
rlRun 'make' 0 "Run default target"
rlRun 'make hello' 0 "Run specific target"
rlRun 'make clean' 0 "Run clean target"
rlRun 'make -s' 0 "make -s: silent mode"


echo ""
echo "All make Basic-Makefile-execution tests passed!"
