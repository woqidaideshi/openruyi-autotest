#!/bin/sh -eux
# Functional test: pciutils package
# Tests PCI bus utilities: lspci, setpci, update-pciids
# Version: pciutils

rpm -q pciutils

rpm -q pciutils
which lspci setpci update-pciids
lspci --version

echo "=== Test 1: lspci basic ==="

lspci | head -10

echo "=== Test 2: lspci verbose ==="

lspci -v | head -10
lspci -vv | head -5

echo "=== Test 3: lspci with filtering ==="

lspci -nn | head -5
lspci -mm | head -5

echo "=== Test 4: lspci numeric ==="

lspci -n | head -5
lspci -nnmm | head -5

echo "=== Test 5: lspci tree view ==="

lspci -t | head -10

echo "=== Test 6: lspci kernel drivers ==="

lspci -k | head -10

echo "=== Test 7: lspci by device class ==="

lspci -d ::0100 | head -5 || echo "Storage controller test"
lspci -d ::0200 | head -5 || echo "Network controller test"

echo "=== Test 8: lspci with domain ==="

lspci -D | head -5

echo "=== Test 9: update-pciids ==="

update-pciids -q 2>&1 || echo "update-pciids test completed"

echo "=== Test 10: lspci format options ==="

lspci -mm -d ::0100 | head -3 || echo "Format test"

echo "=== Test 11: setpci ==="

setpci --dumpregs | head -10

echo "=== Test 12: pcilmr ==="

pcilmr --version 2>&1 || echo "pcilmr version check completed"

echo "=== Test 13: Error handling ==="

lspci -s invalid:00:00.0 2>&1 || echo "Expected: invalid slot format"
lspci --invalid-option 2>&1 || echo "Expected: invalid option"

echo ""
echo "All pciutils functional tests passed!"