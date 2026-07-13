# library-prefix = dejagnu
#
# DejaGnu suite-level shared library
# Uses flag-file + reference counting for suite-level setup/cleanup.
#
# Tests verify:
# - DejaGnu / runtest installation and basic execution
# - GCC testsuite integration (individual test cases)
# - G++ testsuite integration
# - Output content validation (PASS/FAIL counts in.sum files)
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_dejagnu_*/ subdirectories

DEJAGNU_FLAG="/tmp/.beakerlib_compiler_dejagnu_suite"

dejagnuSetup() {
 if [ ! -f "$DEJAGNU_FLAG" ]; then
 if ! rpm -q dejagnu 2>/dev/null; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y dejagnu 2>/dev/null
 if ! rpm -q dejagnu 2>/dev/null; then
 rlLogWarning "dejagnu failed"
 echo "installed=0" > "$DEJAGNU_FLAG"
 else
 echo "installed=1" > "$DEJAGNU_FLAG"
 rlLogInfo "already dejagnu（）"
 fi
 else
 echo "installed=0" > "$DEJAGNU_FLAG"
 rlLogInfo "dejagnu already exists"
 fi
 echo "ref=1" >> "$DEJAGNU_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$DEJAGNU_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$DEJAGNU_FLAG"
 rlLogInfo "dejagnu reference count: $ref"
 fi
 rlCleanupAppend "dejagnuCleanup"
}

dejagnuCleanup() {
 if [ ! -f "$DEJAGNU_FLAG" ]; then return 0; fi
 local ref
 ref=$(grep "^ref=" "$DEJAGNU_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 if grep -q "^installed=1" "$DEJAGNU_FLAG"; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y dejagnu 2>/dev/null || true
 rlLogInfo "already dejagnu"
 fi
 rm -f "$DEJAGNU_FLAG"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$DEJAGNU_FLAG"
 rlLogInfo "dejagnu Retain（still have $ref test）"
 fi
}
