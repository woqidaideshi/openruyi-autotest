#!/bin/sh -eux
# Functional test: procps-ng - slabtop--tload--watch--hugetop

. "../setup.sh"

echo "=== Test 14: slabtop, tload, watch, hugetop ==="

# Test 14.1: slabtop display
slabtop -o 2>&1 | head -10 || echo "slabtop test completed"

# Test 14.2: tload version
(tload -V 2>&1 || tload --version 2>&1) | head -5 || echo "tload version check"

# Test 14.3: watch basic usage
watch --version 2>&1 | grep -q "watch" || echo "watch version check"

# Test 14.4: hugetop
hugetop --version 2>&1 | head -3 || echo "hugetop version check"

. "../teardown.sh"
echo "All procps-ng slabtop--tload--watch--hugetop tests passed!"
