#!/bin/sh -eux
# Functional test: procps-ng - free-command

. "../setup.sh"

echo "=== Test 3: free command ==="

# Test 3.1: Basic memory info
free

# Test 3.2: Human-readable format
free -h

# Test 3.3: Display in different units
free -b
free -k
free -m
free -g

# Test 3.4: Continuous monitoring (single iteration)
free -s 1 -c 1

# Test 3.5: Show total column
free -t

# Test 3.6: Show low/high memory
free -l

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng free-command tests passed!"
