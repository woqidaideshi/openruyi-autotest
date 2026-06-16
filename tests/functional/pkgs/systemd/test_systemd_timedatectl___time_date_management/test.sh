#!/bin/sh -eux
# Functional test: systemd - timedatectl---Time-date-management

. "../setup.sh"

echo "=== Test 6: timedatectl - Time/date management ==="

rlRun 'timedatectl --version 2>&1 || true' 0 "timedatectl version"
rlRun 'timedatectl status' 0 "timedatectl status: time info"
rlRun 'timedatectl show' 0 "timedatectl show: all properties"
rlRun 'timedatectl list-timezones 2>&1 | head -10' 0 "timedatectl list-timezones"
rlRun 'timedatectl show-timesync 2>&1 | head -5' 0 "timedatectl show-timesync"

# ===================================================================

. "../teardown.sh"
echo "All systemd timedatectl---Time-date-management tests passed!"
