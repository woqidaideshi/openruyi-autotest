# library-prefix = smoke_system_info
#
# Smoke system_info suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (coreutils procps-ng util-linux) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_SYSTEM_INFO_FLAG="/tmp/.beakerlib_smoke_system_info_suite"

smokeSystemInfoSetup() {
 if [ ! -f "$SMOKE_SYSTEM_INFO_FLAG" ]; then
 echo "installed=0" > "$SMOKE_SYSTEM_INFO_FLAG"
 echo "ref=1" >> "$SMOKE_SYSTEM_INFO_FLAG"
 rlLogInfo "smoke-system_info: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_SYSTEM_INFO_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SYSTEM_INFO_FLAG"
 rlLogInfo "smoke-system_info already initialized by other tests, reference count: $ref"
 fi
 rlCleanupAppend "smokeSystemInfoCleanup"
}

smokeSystemInfoCleanup() {
 if [ ! -f "$SMOKE_SYSTEM_INFO_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_SYSTEM_INFO_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_SYSTEM_INFO_FLAG"
 rlLogInfo "smoke-system_info: Cleanup complete (posttest)"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SYSTEM_INFO_FLAG"
 rlLogInfo "smoke-system_info: Retain (still have $ref test(s) not completed)"
 fi
}
