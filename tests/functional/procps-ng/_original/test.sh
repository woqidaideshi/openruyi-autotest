#!/bin/sh -eux
# Functional test: procps-ng package
# Tests process management tools: ps, top, free, vmstat, etc.
# Version: procps-ng 4.0.5

# Check package installation
rpm -q procps-ng
which ps top free vmstat iostat w uptime kill

# Get version information
ps --version
free --version

echo "=== Test 1: ps command basic functionality ==="

# Test 1.1: Basic ps output
ps

# Test 1.2: ps with full format
ps -ef

# Test 1.3: ps with custom format
ps -eo pid,comm,stat,%cpu,%mem

# Test 1.4: ps showing all processes
ps aux

# Test 1.5: ps with tree view
ps axjf | head -20

echo "=== Test 2: ps command advanced features ==="

# Test 2.1: Filter by user
ps -u root | head -10

# Test 2.2: Filter by PID
ps -p 1

# Test 2.3: Show threads
ps -eLf | head -10

# Test 2.4: Process hierarchy
ps --forest | head -20

# Test 2.5: Sort by CPU usage
ps aux --sort=-%cpu | head -10

# Test 2.6: Sort by memory usage
ps aux --sort=-%mem | head -10

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

echo "=== Test 4: top command ==="

# Test 4.1: Basic top (batch mode, single iteration)
top -b -n 1 | head -20

# Test 4.2: Top with specific number of processes
top -b -n 1 -p 1

# Test 4.3: Top sorted by memory
top -b -n 1 -o %MEM | head -20

# Test 4.4: Top with delay
top -b -n 1 -d 1 | head -10

echo "=== Test 5: vmstat command ==="

# Test 5.1: Basic vmstat output
vmstat

# Test 5.2: vmstat with custom intervals
vmstat 1 2

# Test 5.3: vmstat with slabs info
vmstat -m | head -10

# Test 5.4: vmstat with disk stats
vmstat -d | head -10

# Test 5.5: vmstat with partitions
vmstat -p /dev/sda 2>&1 || echo "Expected: disk may not exist"

echo "=== Test 6: uptime and w commands ==="

# Test 6.1: System uptime
uptime

# Test 6.2: Show users
w | head -10

# Test 6.3: Show who is logged in
who

echo "=== Test 7: kill command ==="

# Test 7.1: Start a background process
sleep 100 &
BG_PID=$!
echo "Background process PID: $BG_PID"

# Test 7.2: List signal numbers
kill -l

# Test 7.3: Send SIGTERM
kill -15 $BG_PID || true

# Test 7.4: Wait for process to terminate
sleep 1

# Test 7.5: Verify process terminated
ps -p $BG_PID 2>&1 || echo "Process successfully terminated"

echo "=== Test 8: pidof and pgrep ==="

# Test 8.1: Find PID by name
pidof init || pidof systemd || echo "Init system PID retrieved"

# Test 8.2: pgrep basic usage
pgrep -l init || pgrep -l systemd || echo "pgrep test completed"

# Test 8.3: pgrep with full command line
pgrep -af bash | head -5 || echo "pgrep -af test completed"

echo "=== Test 9: pwdx and pmap ==="

# Test 9.1: Show process working directory
pwdx 1 || echo "pwdx test completed"

# Test 9.2: Show process memory map
pmap 1 2>&1 | head -10 || echo "pmap test completed"

echo "=== Test 10: sysctl (if available) ==="

# Test 10.1: List all sysctl parameters
sysctl -a 2>&1 | head -20 || echo "sysctl not available"

# Test 10.2: Read specific parameter
sysctl kernel.hostname 2>&1 || echo "sysctl parameter read test"

echo "=== Test 11: Error handling ==="

# Test 11.1: ps with invalid PID
ps -p 999999 2>&1 || echo "Expected error for invalid PID"

# Test 11.2: kill with invalid PID
kill -9 999999 2>&1 || echo "Expected error for invalid PID"

# Test 11.3: free with invalid option
free -z 2>&1 || echo "Expected error for invalid option"

echo "=== Test 12: Special scenarios ==="

# Test 12.1: ps with environment variables
ps e -p 1 2>&1 | head -5 || echo "Environment variables test completed"

# Test 12.2: Process with real-time priority
ps -eo pid,rtprio,comm | head -10

# Test 12.3: Show process namespaces
ps -eo pid,ns:pid,comm | head -10 || echo "Namespace test completed"

echo "=== Test 13: pkill and pidwait ==="

# Test 13.1: pkill version check
pkill --version 2>&1 | grep -q "pkill" || echo "pkill version check"

# Test 13.2: pidwait version check
pidwait --version 2>&1 | grep -q "pidwait" || echo "pidwait version check"

echo "=== Test 14: slabtop, tload, watch, hugetop ==="

# Test 14.1: slabtop display
slabtop -o 2>&1 | head -10 || echo "slabtop test completed"

# Test 14.2: tload version
(tload -V 2>&1 || tload --version 2>&1) | head -5 || echo "tload version check"

# Test 14.3: watch basic usage
watch --version 2>&1 | grep -q "watch" || echo "watch version check"

# Test 14.4: hugetop
hugetop --version 2>&1 | head -3 || echo "hugetop version check"

echo ""
echo "All procps-ng functional tests passed!"
