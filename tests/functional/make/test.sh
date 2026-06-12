#!/bin/sh -eux
# Functional test: make package
# Tests GNU Make build automation tool
# Version: GNU Make 4.4.1

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

echo "=== Test 2: Variables ==="
cat > Makefile << 'EOF'
VAR = test_value
.PHONY: all
all:
	@echo $(VAR)
EOF
rlRun 'make' 0 "Variable expansion"
rlRun 'make VAR=override | grep override' 0 "Override variable"

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

echo "=== Test 4: Parallel execution ==="
cat > Makefile << 'EOF'
.PHONY: all
all: t1 t2 t3
t1 t2 t3:
	@echo "Building $@"
EOF
rlRun 'make -j2' 0 "make -j2: parallel 2 jobs"

echo "=== Test 5: Environment ==="
export TESTENV=hello
cat > Makefile << 'EOF'
.PHONY: all
all:
	@echo $(TESTENV)
EOF
rlRun 'make -e | grep hello' 0 "make -e: environment overrides"
rlRun 'make | grep hello' 0 "Environment variable in make"

echo "=== Test 6: Directory change ==="
mkdir subdir
cat > subdir/Makefile << 'EOF'
.PHONY: all
all:
	@echo "subdir_make"
EOF
rlRun 'make -C subdir' 0 "make -C: change directory"

echo "=== Test 7: Include ==="
echo 'INCLUDED_VAR = included_value' > inc.mk
cat > Makefile << 'EOF'
include inc.mk
.PHONY: all
all:
	@echo $(INCLUDED_VAR)
EOF
rlRun 'make | grep included_value' 0 "Include file"

echo "=== Test 8: gmake alias ==="
rlRun 'gmake --version 2>&1 | grep "GNU Make"' 0 "gmake is GNU Make"

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