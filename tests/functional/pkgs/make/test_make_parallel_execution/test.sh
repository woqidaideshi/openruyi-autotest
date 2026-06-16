#!/bin/sh -eux
# Functional test: make - Parallel-execution

. "../setup.sh"

echo "=== Test 4: Parallel execution ==="
cat > Makefile << 'EOF'
.PHONY: all
all: t1 t2 t3
t1 t2 t3:
	@echo "Building $@"
EOF
rlRun 'make -j2' 0 "make -j2: parallel 2 jobs"

. "../teardown.sh"
echo "All make Parallel-execution tests passed!"
