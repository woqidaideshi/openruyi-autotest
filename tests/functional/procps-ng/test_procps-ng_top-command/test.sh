#!/bin/sh -eux
# Functional test: procps-ng - top-command

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: top command ==="

# Test 4.1: Basic top (batch mode, single iteration)
top -b -n 1 | head -20

# Test 4.2: Top with specific number of processes
top -b -n 1 -p 1

# Test 4.3: Top sorted by memory
top -b -n 1 -o %MEM | head -20

# Test 4.4: Top with delay
top -b -n 1 -d 1 | head -10

cd /
rm -rf $TmpDir

echo ""
echo "All procps-ng top-command tests passed!"
