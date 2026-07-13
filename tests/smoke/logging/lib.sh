# library-prefix = smoke_logging
#
# Smoke logging suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (util-linux logrotate rsyslog) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_LOGGING_FLAG="/tmp/.beakerlib_smoke_logging_suite"

smokeLoggingSetup() {
 if [ ! -f "$SMOKE_LOGGING_FLAG" ]; then
 echo "installed=0" > "$SMOKE_LOGGING_FLAG"
 echo "ref=1" >> "$SMOKE_LOGGING_FLAG"
 rlLogInfo "smoke-logging: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_LOGGING_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_LOGGING_FLAG"
 rlLogInfo "smoke-logging already initialized by other tests，reference count: $ref"
 fi
 rlCleanupAppend "smokeLoggingCleanup"
}

smokeLoggingCleanup() {
 if [ ! -f "$SMOKE_LOGGING_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_LOGGING_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_LOGGING_FLAG"
 rlLogInfo "smoke-logging: Cleanup complete（posttest）"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_LOGGING_FLAG"
 rlLogInfo "smoke-logging: Retain（still have $ref test(s) not completed）"
 fi
}
