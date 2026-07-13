# library-prefix = smoke_shell_basics
#
# Smoke shell_basics suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (bash coreutils) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_SHELL_BASICS_FLAG="/tmp/.beakerlib_smoke_shell_basics_suite"

smokeShellBasicsSetup() {
 if [ ! -f "$SMOKE_SHELL_BASICS_FLAG" ]; then
 echo "installed=0" > "$SMOKE_SHELL_BASICS_FLAG"
 echo "ref=1" >> "$SMOKE_SHELL_BASICS_FLAG"
 rlLogInfo "smoke-shell_basics: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_SHELL_BASICS_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SHELL_BASICS_FLAG"
 rlLogInfo "smoke-shell_basics already initialized by other tests, reference count: $ref"
 fi
 rlCleanupAppend "smokeShellBasicsCleanup"
}

smokeShellBasicsCleanup() {
 if [ ! -f "$SMOKE_SHELL_BASICS_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_SHELL_BASICS_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_SHELL_BASICS_FLAG"
 rlLogInfo "smoke-shell_basics: Cleanup complete (posttest)"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SHELL_BASICS_FLAG"
 rlLogInfo "smoke-shell_basics: Retain (still have $ref test(s) not completed)"
 fi
}
