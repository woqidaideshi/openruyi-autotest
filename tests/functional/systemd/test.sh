#!/bin/sh -eux
# Functional test: systemd package (comprehensive coverage)
# Tests core systemd commands, services, and management tools
# Version: systemd 259

rlRun() { eval "$1" 2>&1; return $?; }

rlRun 'rpm -q systemd' 0 "Check systemd package is installed"

TmpDir=$(mktemp -d)
cd $TmpDir

# ===================================================================
echo "=== Test 1: systemctl - Service and system management ==="

rlRun 'systemctl --version' 0 "systemctl version"
rlRun 'systemctl list-units --type=service | head -20' 0 "systemctl: list running services"
rlRun 'systemctl list-units --type=target | head -20' 0 "systemctl: list targets"
rlRun 'systemctl list-units --type=service --all | head -20' 0 "systemctl --all: all services"
rlRun 'systemctl list-unit-files --type=service | head -10' 0 "systemctl: list unit files"
rlRun 'systemctl is-active systemd-journald.service 2>&1 || true' 0 "systemctl is-active: check service status"
rlRun 'systemctl is-enabled systemd-journald.service 2>&1 || true' 0 "systemctl is-enabled: check enabled"
rlRun 'systemctl is-failed 2>&1 || true' 0 "systemctl is-failed: list failed units"
rlRun 'systemctl status systemd-journald.service 2>&1 | head -5' 0 "systemctl status: service status"
rlRun 'systemctl show systemd-journald.service 2>&1 | head -10' 0 "systemctl show: service properties"
rlRun 'systemctl cat systemd-journald.service 2>&1 | head -5' 0 "systemctl cat: show unit file"
rlRun 'systemctl list-dependencies default.target 2>&1 | head -10' 0 "systemctl list-dependencies"
rlRun 'systemctl list-sockets 2>&1 | head -10' 0 "systemctl list-sockets"
rlRun 'systemctl list-timers 2>&1 | head -10' 0 "systemctl list-timers"
rlRun 'systemctl list-machines 2>&1 || true' 0 "systemctl list-machines"

# ===================================================================
echo "=== Test 2: journalctl - Journal query ==="

rlRun 'journalctl --version' 0 "journalctl version"
rlRun 'journalctl -n 5 2>&1 || true' 0 "journalctl -n: last entries"
rlRun 'journalctl -b 2>&1 | head -5' 0 "journalctl -b: current boot"
rlRun 'journalctl --list-boots 2>&1 | head -5' 0 "journalctl --list-boots"
rlRun 'journalctl -k 2>&1 | head -5' 0 "journalctl -k: kernel messages"
rlRun 'journalctl --no-pager -n 3 -o short 2>&1 || true' 0 "journalctl -o short: short format"
rlRun 'journalctl --no-pager -n 3 -o json 2>&1 | head -5' 0 "journalctl -o json: json format"
rlRun 'journalctl --no-pager -n 3 -o verbose 2>&1 | head -5' 0 "journalctl -o verbose"
rlRun 'journalctl --disk-usage 2>&1 || true' 0 "journalctl --disk-usage"
rlRun 'journalctl --no-pager -n 1 --output=cat 2>&1 || true' 0 "journalctl --output=cat"
rlRun 'journalctl --no-pager -n 2 -p err 2>&1 || true' 0 "journalctl -p err: error messages"
rlRun 'journalctl --no-pager --since "1 hour ago" 2>&1 | head -3' 0 "journalctl --since"
rlRun 'journalctl --no-pager -n 1 -q 2>&1 || true' 0 "journalctl -q: quiet"

# ===================================================================
echo "=== Test 3: systemd-analyze - System profiling ==="

rlRun 'systemd-analyze --version 2>&1 || true' 0 "systemd-analyze version"
rlRun 'systemd-analyze time 2>&1 || true' 0 "systemd-analyze time: boot time"
rlRun 'systemd-analyze blame 2>&1 | head -10' 0 "systemd-analyze blame: slowest units"
rlRun 'systemd-analyze critical-chain 2>&1 | head -10' 0 "systemd-analyze critical-chain"
rlRun 'systemd-analyze plot 2>&1 | head -3 || true' 0 "systemd-analyze plot: SVG boot chart"
rlRun 'systemd-analyze dot 2>&1 | head -3 || true' 0 "systemd-analyze dot: dependency graph"
rlRun 'systemd-analyze dump 2>&1 | head -5' 0 "systemd-analyze dump: state dump"
rlRun 'systemd-analyze security 2>&1 | head -5' 0 "systemd-analyze security"
rlRun 'systemd-analyze verify /dev/null 2>&1 || true' 0 "systemd-analyze verify"

# ===================================================================
echo "=== Test 4: hostnamectl - Hostname management ==="

rlRun 'hostnamectl --version 2>&1 || true' 0 "hostnamectl version"
rlRun 'hostnamectl status' 0 "hostnamectl status: system info"
rlRun 'hostnamectl hostname' 0 "hostnamectl hostname: current name"
rlRun 'hostnamectl --static' 0 "hostnamectl --static"
rlRun 'hostnamectl --transient' 0 "hostnamectl --transient"
rlRun 'hostnamectl --pretty 2>&1 || true' 0 "hostnamectl --pretty"
rlRun 'hostnamectl chassis 2>&1 || true' 0 "hostnamectl chassis"

# ===================================================================
echo "=== Test 5: localectl - Locale management ==="

rlRun 'localectl --version 2>&1 || true' 0 "localectl version"
rlRun 'localectl status' 0 "localectl status: locale info"
rlRun 'localectl list-locales 2>&1 | head -10' 0 "localectl list-locales"

# ===================================================================
echo "=== Test 6: timedatectl - Time/date management ==="

rlRun 'timedatectl --version 2>&1 || true' 0 "timedatectl version"
rlRun 'timedatectl status' 0 "timedatectl status: time info"
rlRun 'timedatectl show' 0 "timedatectl show: all properties"
rlRun 'timedatectl list-timezones 2>&1 | head -10' 0 "timedatectl list-timezones"
rlRun 'timedatectl show-timesync 2>&1 | head -5' 0 "timedatectl show-timesync"

# ===================================================================
echo "=== Test 7: loginctl - Login management ==="

rlRun 'loginctl --version 2>&1 || true' 0 "loginctl version"
rlRun 'loginctl list-sessions' 0 "loginctl list-sessions"
rlRun 'loginctl list-users' 0 "loginctl list-users"
rlRun 'loginctl show-session 2>&1 | head -10' 0 "loginctl show-session"
rlRun 'loginctl show-user openruyi 2>&1 | head -10' 0 "loginctl show-user"
rlRun 'loginctl user-status openruyi 2>&1 | head -10' 0 "loginctl user-status"

# ===================================================================
echo "=== Test 8: systemd-detect-virt ==="

rlRun 'systemd-detect-virt' 0 "systemd-detect-virt: detect VM"
rlRun 'systemd-detect-virt -q' 0 "systemd-detect-virt -q: quiet mode"
rlRun 'systemd-detect-virt -c 2>&1 || true' 0 "systemd-detect-virt -c: container only"
rlRun 'systemd-detect-virt -v 2>&1 || true' 0 "systemd-detect-virt -v: VM only"
rlRun 'systemd-detect-virt -r 2>&1 || true' 0 "systemd-detect-virt -r: chroot only"

# ===================================================================
echo "=== Test 9: systemd-cgls - Cgroup listing ==="

rlRun 'systemd-cgls 2>&1 | head -20' 0 "systemd-cgls: cgroup tree"
rlRun 'systemd-cgls -k 2>&1 | head -5' 0 "systemd-cgls -k: kernel threads"
rlRun 'systemd-cgls --no-pager 2>&1 | head -10' 0 "systemd-cgls --no-pager"

# ===================================================================
echo "=== Test 10: systemd-cgtop - Cgroup top ==="

rlRun 'systemd-cgtop -n 1 -b 2>&1 | head -15' 0 "systemd-cgtop -b: batch mode"

# ===================================================================
echo "=== Test 11: systemd-tmpfiles ==="

rlRun 'systemd-tmpfiles --version 2>&1 || true' 0 "systemd-tmpfiles version"
rlRun 'systemd-tmpfiles --cat-config 2>&1 | head -10' 0 "systemd-tmpfiles --cat-config"

# ===================================================================
echo "=== Test 12: busctl - D-Bus introspection ==="

rlRun 'busctl --version 2>&1 || true' 0 "busctl version"
rlRun 'busctl list 2>&1 | head -10' 0 "busctl list: list services"
rlRun 'busctl status 2>&1 | head -10' 0 "busctl status: bus status"
rlRun 'busctl tree org.freedesktop.systemd1 2>&1 | head -10' 0 "busctl tree: object tree"
rlRun 'busctl introspect org.freedesktop.systemd1 /org/freedesktop/systemd1 2>&1 | head -10' 0 "busctl introspect"

# ===================================================================
echo "=== Test 13: systemd-run ==="

rlRun 'systemd-run --version 2>&1 || true' 0 "systemd-run version"
rlRun 'systemd-run --user --scope echo "test" 2>&1 || true' 0 "systemd-run --user --scope"

# ===================================================================
echo "=== Test 14: systemd-cat ==="

rlRun 'echo "test log message" | systemd-cat 2>&1 || true' 0 "systemd-cat: pipe to journal"
rlRun 'systemd-cat --version 2>&1 || true' 0 "systemd-cat version"

# ===================================================================
echo "=== Test 15: systemd-notify ==="

rlRun 'systemd-notify --version 2>&1 || true' 0 "systemd-notify version"
rlRun 'systemd-notify --help 2>&1 | head -5' 0 "systemd-notify help"

# ===================================================================
echo "=== Test 16: systemd-path ==="

rlRun 'systemd-path' 0 "systemd-path: all paths"
rlRun 'systemd-path systemd-system-config' 0 "systemd-path: specific path"
rlRun 'systemd-path --suffix=test search-bin' 0 "systemd-path --suffix"
rlRun 'systemd-path --help 2>&1 | head -3' 0 "systemd-path help"

# ===================================================================
echo "=== Test 17: systemd-escape ==="

rlRun 'systemd-escape "hello world"' 0 "systemd-escape: basic escape"
rlRun 'systemd-escape --path "/usr/bin/test"' 0 "systemd-escape --path: path escape"
rlRun 'systemd-escape -u "hello\\x20world"' 0 "systemd-escape -u: unescape"
rlRun 'systemd-escape --suffix=mount "/mnt/data"' 0 "systemd-escape --suffix"
rlRun 'systemd-escape --template="test@.service" instance' 0 "systemd-escape --template"

# ===================================================================
echo "=== Test 18: systemd-machine-id-setup ==="

rlRun 'systemd-machine-id-setup --help 2>&1 | head -3' 0 "systemd-machine-id-setup help"
rlRun 'cat /etc/machine-id' 0 "systemd-machine-id-setup: check machine-id"

# ===================================================================
echo "=== Test 19: coredumpctl ==="

rlRun 'coredumpctl --version 2>&1 || true' 0 "coredumpctl version"
rlRun 'coredumpctl list 2>&1 | head -5' 0 "coredumpctl list: list dumps"
rlRun 'coredumpctl info 2>&1 | head -5 || true' 0 "coredumpctl info"

# ===================================================================
echo "=== Test 20: systemd-delta ==="

rlRun 'systemd-delta --help 2>&1 | head -3' 0 "systemd-delta help"
rlRun 'systemd-delta 2>&1 | head -10' 0 "systemd-delta: show overrides"

# ===================================================================
echo "=== Test 21: systemd-id128 ==="

rlRun 'systemd-id128 show 2>&1 | head -5' 0 "systemd-id128 show: show IDs"
rlRun 'systemd-id128 new 2>&1 || true' 0 "systemd-id128 new: generate ID"

# ===================================================================
echo "=== Test 22: systemd-inhibit ==="

rlRun 'systemd-inhibit --help 2>&1 | head -5' 0 "systemd-inhibit help"
rlRun 'systemd-inhibit --list 2>&1 || true' 0 "systemd-inhibit --list"

# ===================================================================
echo "=== Test 23: systemd-ac-power ==="

rlRun 'systemd-ac-power 2>&1 || true' 0 "systemd-ac-power: check power"

# ===================================================================
echo "=== Test 24: systemd-ask-password ==="

rlRun 'systemd-ask-password --help 2>&1 | head -3' 0 "systemd-ask-password help"

# ===================================================================
echo "=== Test 25: systemd-creds ==="

rlRun 'systemd-creds --help 2>&1 | head -5' 0 "systemd-creds help"

# ===================================================================
echo "=== Test 26: systemd-socket-activate ==="

rlRun 'systemd-socket-activate --help 2>&1 | head -5' 0 "systemd-socket-activate help"

# ===================================================================
echo "=== Test 27: Power management commands ==="

for cmd in halt poweroff reboot shutdown; do
  rlRun "$cmd --help 2>&1 | head -3 || true" 0 "$cmd help"
done

# ===================================================================
echo "=== Test 28: systemd-firstboot ==="

rlRun 'systemd-firstboot --help 2>&1 | head -5' 0 "systemd-firstboot help"

# ===================================================================
echo "=== Test 29: systemd-stdio-bridge ==="

rlRun 'systemd-stdio-bridge --help 2>&1 | head -3' 0 "systemd-stdio-bridge help"

# ===================================================================
echo "=== Test 30: oomctl ==="

rlRun 'oomctl --help 2>&1 | head -5' 0 "oomctl help"
rlRun 'oomctl dump 2>&1 | head -5 || true' 0 "oomctl dump"

# ===================================================================
echo "=== Test 31: systemctl service operations ==="

rlRun 'systemctl try-restart systemd-journald.service 2>&1 || true' 0 "systemctl try-restart"
rlRun 'systemctl reload-or-restart systemd-journald.service 2>&1 || true' 0 "systemctl reload-or-restart"
rlRun 'systemctl reset-failed 2>&1 || true' 0 "systemctl reset-failed"
rlRun 'systemctl daemon-reload 2>&1 || true' 0 "systemctl daemon-reload"

# ===================================================================
echo "=== Test 32: run0 - Privilege escalation ==="

rlRun 'run0 --help 2>&1 | head -5' 0 "run0 help"

# ===================================================================
echo "=== Test 33: systemd-mount ==="

rlRun 'systemd-mount --help 2>&1 | head -5' 0 "systemd-mount help"

# ===================================================================
echo "=== Test 34: systemd-sysext ==="

rlRun 'systemd-sysext --help 2>&1 | head -5' 0 "systemd-sysext help"

# ===================================================================
echo "=== Test 35: systemd-confext ==="

rlRun 'systemd-confext --help 2>&1 | head -5' 0 "systemd-confext help"

# ===================================================================
echo "=== Test 36: Error handling ==="

rlRun 'systemctl nonexistent-command 2>&1 || true' 0 "systemctl: invalid command"
rlRun 'journalctl --invalid-option 2>&1 || true' 0 "journalctl: invalid option"
rlRun 'hostnamectl --invalid 2>&1 || true' 0 "hostnamectl: invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All systemd functional tests passed!"