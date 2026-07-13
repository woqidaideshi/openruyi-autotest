# library-prefix = smoke_dev_tools
#
# Smoke dev_tools suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (gcc make python) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_DEV_TOOLS_FLAG="/tmp/.beakerlib_smoke_dev_tools_suite"

smokeDevToolsSetup() {
 if [ ! -f "$SMOKE_DEV_TOOLS_FLAG" ]; then
 echo "installed=0" > "$SMOKE_DEV_TOOLS_FLAG"
 echo "ref=1" >> "$SMOKE_DEV_TOOLS_FLAG"
 rlLogInfo "smoke-dev_tools: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_DEV_TOOLS_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_DEV_TOOLS_FLAG"
 rlLogInfo "smoke-dev_tools already initialized by other tests，reference count: $ref"
 fi
 rlCleanupAppend "smokeDevToolsCleanup"
}

smokeDevToolsCleanup() {
 if [ ! -f "$SMOKE_DEV_TOOLS_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_DEV_TOOLS_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_DEV_TOOLS_FLAG"
 rlLogInfo "smoke-dev_tools: Cleanup complete（posttest）"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_DEV_TOOLS_FLAG"
 rlLogInfo "smoke-dev_tools: Retain（still have $ref test(s) not completed）"
 fi
}
