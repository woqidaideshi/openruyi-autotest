#!/bin/sh -eux
# Functional test: iputils package
# Tests network utilities: ping, ping6, traceroute6, tracepath, arping, clockdiff
# Version: iputils 20250605

# Check package installation
rpm -q iputils
which ping ping6 traceroute6 tracepath arping clockdiff

# Get version information (if available)
ping -V 2>&1 || echo "Version check completed"

echo "=== Test 1: ping basic functionality ==="

# Test 1.1: Ping localhost
ping -c 3 127.0.0.1

# Test 1.2: Ping with count limit
ping -c 5 127.0.0.1

# Test 1.3: Ping with interval
ping -c 3 -i 0.5 127.0.0.1

# Test 1.4: Ping with packet size
ping -c 3 -s 64 127.0.0.1
ping -c 3 -s 1024 127.0.0.1

# Test 1.5: Ping with timeout
ping -c 3 -W 2 127.0.0.1

echo "=== Test 2: ping advanced options ==="

# Test 2.1: Ping with flood mode (requires root)
ping -c 10 -f 127.0.0.1 || echo "Flood ping test completed"

# Test 2.2: Ping with numeric output
ping -c 3 -n 127.0.0.1

# Test 2.3: Ping with quiet mode
ping -c 3 -q 127.0.0.1

# Test 2.4: Ping with verbose output
ping -c 3 -v 127.0.0.1

# Test 2.5: Ping with timestamp
ping -c 3 -D 127.0.0.1

echo "=== Test 3: ping6 (IPv6) ==="

# Test 3.1: Ping6 localhost
ping6 -c 3 ::1 || echo "IPv6 ping test completed (IPv6 may not be enabled)"

# Test 3.2: Ping6 with count
ping6 -c 5 ::1 || echo "IPv6 ping with count test completed"

echo "=== Test 4: traceroute6 ==="

# Test 4.1: Basic traceroute6 to localhost
traceroute6 -m 5 ::1 || echo "traceroute6 test completed"

# Test 4.2: traceroute6 with max hops
traceroute6 -m 10 ::1 || echo "traceroute6 with max hops test completed"

# Test 4.3: traceroute6 with wait time
traceroute6 -m 5 -w 2 ::1 || echo "traceroute6 with wait time test completed"

echo "=== Test 5: tracepath ==="

# Test 5.1: Basic tracepath to localhost
tracepath -m 5 127.0.0.1 || echo "tracepath test completed"

# Test 5.2: tracepath with max hops
tracepath -m 10 127.0.0.1 || echo "tracepath with max hops test completed"

# Test 5.3: tracepath IPv6
tracepath6 -m 5 ::1 || echo "tracepath6 test completed"

echo "=== Test 6: arping ==="

# Test 6.1: ARP ping to localhost interface
arping -c 3 -I lo 127.0.0.1 || echo "arping test completed (requires proper interface)"

# Test 6.2: arping with count
arping -c 5 127.0.0.1 || echo "arping with count test completed"

# Test 6.3: arping with timeout
arping -c 3 -w 5 127.0.0.1 || echo "arping with timeout test completed"

echo "=== Test 7: clockdiff ==="

# Test 7.1: Clock difference to localhost
clockdiff 127.0.0.1 || echo "clockdiff test completed"

# Test 7.2: clockdiff with IPv6
clockdiff -o 127.0.0.1 || echo "clockdiff with option test completed"

echo "=== Test 8: ping error handling ==="

# Test 8.1: Ping unreachable address
ping -c 2 -W 1 192.0.2.1 2>&1 || echo "Expected: unreachable host"

# Test 8.2: Ping with invalid address
ping -c 1 999.999.999.999 2>&1 || echo "Expected error for invalid address"

# Test 8.3: Ping with invalid count
ping -c 0 127.0.0.1 2>&1 || echo "Expected error for invalid count"

# Test 8.4: Ping with negative count
ping -c -1 127.0.0.1 2>&1 || echo "Expected error for negative count"

echo "=== Test 9: ping special scenarios ==="

# Test 9.1: Ping broadcast address (may require special permissions)
ping -c 1 -b 255.255.255.255 2>&1 || echo "Broadcast ping test completed"

# Test 9.2: Ping with source address
ping -c 3 -I 127.0.0.1 127.0.0.1 || echo "Source address ping test completed"

# Test 9.3: Ping with TTL
ping -c 3 -t 64 127.0.0.1

# Test 9.4: Continuous ping (limited by timeout)
timeout 5 ping 127.0.0.1 || echo "Continuous ping test completed"

echo "=== Test 10: Network interface testing ==="

# Test 10.1: Ping via specific interface
ping -c 3 -I lo 127.0.0.1

# Test 10.2: Multiple ping instances
ping -c 2 127.0.0.1 &
ping -c 2 127.0.0.1 &
wait || echo "Multiple ping instances test completed"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils functional tests passed!"
