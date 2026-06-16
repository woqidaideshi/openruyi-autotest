#!/bin/sh -eux
# Functional test: make - Basic-Makefile-execution

. "../setup.sh"

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

. "../teardown.sh"
echo "All make Basic-Makefile-execution tests passed!"
