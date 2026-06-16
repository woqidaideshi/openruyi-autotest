#!/bin/sh -eux
# Functional test: make - Options

. "../setup.sh"

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

. "../teardown.sh"
echo "All make Options tests passed!"
