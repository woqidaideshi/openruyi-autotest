#!/bin/sh -eux
# Functional test: gcc - Assembly-output

. "../setup.sh"

echo "=== Test 5: Assembly output ==="

# Test 5.1: Generate assembly (-S)
rlRun 'gcc -S hello.c -o hello.s' 0 "Generate assembly with -S"
rlRun 'grep -q "main:" hello.s' 0 "Check main label in assembly"

# Test 5.2: Assemble .s file to object
rlRun 'as hello.s -o hello_obj.o' 0 "Assemble to object file"

. "../teardown.sh"
echo "All gcc Assembly-output tests passed!"
