# library-prefix = smoke_service_mgmt
#
# Smoke service_mgmt suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (systemd) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_SERVICE_MGMT_FLAG="/tmp/.beakerlib_smoke_service_mgmt_suite"

smokeServiceMgmtSetup() {
 if [ ! -f "$SMOKE_SERVICE_MGMT_FLAG" ]; then
 echo "installed=0" > "$SMOKE_SERVICE_MGMT_FLAG"
 echo "ref=1" >> "$SMOKE_SERVICE_MGMT_FLAG"
 rlLogInfo "smoke-service_mgmt: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_SERVICE_MGMT_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SERVICE_MGMT_FLAG"
 rlLogInfo "smoke-service_mgmt already initialized by other tests, reference count: $ref"
 fi
 rlCleanupAppend "smokeServiceMgmtCleanup"
}

smokeServiceMgmtCleanup() {
 if [ ! -f "$SMOKE_SERVICE_MGMT_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_SERVICE_MGMT_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_SERVICE_MGMT_FLAG"
 rlLogInfo "smoke-service_mgmt: Cleanup complete (posttest)"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SERVICE_MGMT_FLAG"
 rlLogInfo "smoke-service_mgmt: Retain (still have $ref test(s) not completed)"
 fi
}
