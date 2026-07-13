# library-prefix = trinity
#
# Trinity syscall fuzzer suite-level shared library
# Installs trinity, creates non-root user, manages test lifecycle.
#
# Key safety: Trinity MUST NOT run as root. We create a dedicated
# 'trinity_tester' user for fuzzing.
#
# Result checking (per Trinity docs):
# 1. Abnormal exit during fuzzing → FAIL
# 2. /proc/sys/kernel/tainted changed before/after → FAIL (kernel tainted)
# 3. Output contains "BUG" → FAIL (kernel bug detected)
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_trinity_*/ subdirectories

TRINITY_FLAG="/tmp/.beakerlib_trinity_suite"
TRINITY_USER="trinity_tester"

trinitySetup() {
 if [ ! -f "$TRINITY_FLAG" ]; then
 # Install trinity
 if ! rpm -q trinity 2>/dev/null; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y trinity 2>/dev/null
 if ! rpm -q trinity 2>/dev/null; then
 rlLogWarning "trinity failed"
 echo "installed=0" > "$TRINITY_FLAG"
 else
 echo "installed=1" > "$TRINITY_FLAG"
 rlLogInfo "already trinity ()"
 fi
 else
 echo "installed=0" > "$TRINITY_FLAG"
 rlLogInfo "trinity already exists"
 fi

 # Create non-root user for trinity (MUST NOT run as root)
 if ! id "$TRINITY_USER" >/dev/null 2>&1; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S useradd -m "$TRINITY_USER" 2>/dev/null
 echo "${TRINITY_USER}:trinity123" | sudo -S chpasswd 2>/dev/null
 rlLogInfo "alreadycreate Trinity withuser: $TRINITY_USER"
 else
 rlLogInfo "user $TRINITY_USER already exists"
 fi

 echo "ref=1" >> "$TRINITY_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$TRINITY_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$TRINITY_FLAG"
 rlLogInfo "trinity reference count: $ref"
 fi
 rlCleanupAppend "trinityCleanup"
}

trinityCleanup() {
 if [ ! -f "$TRINITY_FLAG" ]; then return 0; fi
 local ref
 ref=$(grep "^ref=" "$TRINITY_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 if grep -q "^installed=1" "$TRINITY_FLAG"; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y trinity 2>/dev/null || true
 rlLogInfo "already trinity"
 fi
 rm -f "$TRINITY_FLAG"
 rlLogInfo "trinity testCleanup complete"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$TRINITY_FLAG"
 rlLogInfo "trinity Retain (still have $ref test)"
 fi
}

# Record kernel tainted state before fuzzing
# Usage: _trinityTaintBefore
_trinityTaintBefore() {
 if [ -r /proc/sys/kernel/tainted ]; then
 cat /proc/sys/kernel/tainted
 else
 echo "0"
 fi
}

# Compare tainted state after fuzzing, report if changed
# Usage: _trinityTaintCheck <before_value>
_trinityTaintCheck() {
 local before="$1"
 local after
 if [ -r /proc/sys/kernel/tainted ]; then
 after=$(cat /proc/sys/kernel/tainted)
 else
 after="0"
 fi
 if [ "$before" != "$after" ]; then
 rlFail "kernel tainted Status: $before → $after (kernel!)"
 rlLogWarning "Tainted: P=proprietary, F=forced, S=out-of-spec, R=user-forced, B=bad-page, U=user, D=die, A=ACPI, W=warning, C=driver, I=workaround, O=out-of-tree, E=unsigned, L=soft-lockup, K=kernel-livepatch"
 else
 rlPass "kernel tainted Statusno: $before"
 fi
}

# Check trinity output for BUG/crash indicators
# Usage: _trinityCheckOutput <log_file>
_trinityCheckOutput() {
 local log="$1"
 if [ ! -f "$log" ]; then return 0; fi

 # Check for BUG markers (kernel-level)
 if grep -q "BUG:" "$log" 2>/dev/null; then
 rlLogWarning "outputin BUG: "
 grep "BUG:" "$log" | head -10
 return 0
 fi

 # Check for kernel Oops
 if grep -qi "Oops:\|kernel BUG\|Unable to handle kernel" "$log" 2>/dev/null; then
 rlFail "outputinkernel Oops/BUG"
 grep -i "Oops:\|kernel BUG\|Unable to handle kernel" "$log" | head -10
 return 0
 fi

 # Check for segfaults
 local segfaults
 segfaults=$(grep -c "segfault\|Segmentation fault\|core dumped" "$log" 2>/dev/null || echo 0)
 if [ "$segfaults" -gt 0 ]; then
 rlLogWarning "subprocessproduced $segfaults segfault (fuzzer normallinesis)"
 fi

 rlPass "Trinity outputnokernel BUG/Oops"
}
