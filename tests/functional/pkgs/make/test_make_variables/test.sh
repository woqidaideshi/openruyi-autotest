#!/bin/sh -eux
# Functional test: make - Variables

. "../setup.sh"

echo "=== Test 2: Variables ==="
cat > Makefile << 'EOF'
VAR = test_value
.PHONY: all
all:
	@echo $(VAR)
EOF
rlRun 'make' 0 "Variable expansion"
rlRun 'make VAR=override | grep override' 0 "Override variable"

. "../teardown.sh"
echo "All make Variables tests passed!"
