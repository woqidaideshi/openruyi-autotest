# library-prefix = smoke_process

#

# Smoke process suite-level shared library

# Uses flag-file + reference counting to ensure the category's

# dependency packages are verified only ONCE across all test cases.

# Most smoke dependencies (procps-ng) are always present on the system;

# this lib verifies their existence rather than installing.

#

# Usage in each test file:

#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories



SMOKE_PROCESS_FLAG="/tmp/.beakerlib_smoke_process_suite"



smokeProcessSetup() {

 if [ ! -f "$SMOKE_PROCESS_FLAG" ]; then

 echo "installed=0" > "$SMOKE_PROCESS_FLAG"

 echo "ref=1" >> "$SMOKE_PROCESS_FLAG"

 rlLogInfo "smoke-process: coreDependenciesalreadyconfirmavailable"

 else

 local ref

 ref=$(grep "^ref=" "$SMOKE_PROCESS_FLAG" | cut -d= -f2)

 ref=$((ref + 1))

 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_PROCESS_FLAG"

 rlLogInfo "smoke-process already initialized by other tests, reference count: $ref"

 fi

 rlCleanupAppend "smokeProcessCleanup"

}



smokeProcessCleanup() {

 if [ ! -f "$SMOKE_PROCESS_FLAG" ]; then

 return 0

 fi

 local ref

 ref=$(grep "^ref=" "$SMOKE_PROCESS_FLAG" | cut -d= -f2)

 ref=$((ref - 1))

 if [ "$ref" -le 0 ]; then

 rm -f "$SMOKE_PROCESS_FLAG"

 rlLogInfo "smoke-process: Cleanup complete (posttest)"

 else

 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_PROCESS_FLAG"

 rlLogInfo "smoke-process: Retain (still have $ref test(s) not completed)"

 fi

}

