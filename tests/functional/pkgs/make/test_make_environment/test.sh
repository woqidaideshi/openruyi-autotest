#!/bin/sh -eux
# Functional test: make - Environment

. "../setup.sh"

echo "=== Test 5: Environment ==="
export TESTENV=hello
cat > Makefile << 'EOF'
.PHONY: all
all:
	@echo $(TESTENV)
EOF
rlRun 'make -e | grep hello' 0 "make -e: environment overrides"
rlRun 'make | grep hello' 0 "Environment variable in make"

. "../teardown.sh"
echo "All make Environment tests passed!"
