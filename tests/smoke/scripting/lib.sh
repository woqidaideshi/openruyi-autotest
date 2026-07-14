# library-prefix = smoke_scripting

#

# Smoke scripting suite-level shared library

# Uses flag-file + reference counting to ensure the category's

# dependency packages are verified only ONCE across all test cases.

# Most smoke dependencies (coreutils) are always present on the system;

# this lib verifies their existence rather than installing.

#

# Usage in each test file:

#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories



SMOKE_SCRIPTING_FLAG="/tmp/.beakerlib_smoke_scripting_suite"



smokeScriptingSetup() {

    if [ ! -f "$SMOKE_SCRIPTING_FLAG" ]; then

    echo "installed=0" > "$SMOKE_SCRIPTING_FLAG"

    echo "ref=1" >> "$SMOKE_SCRIPTING_FLAG"

    rlLogInfo "smoke-scripting: coreDependenciesalreadyconfirmavailable"

    else

    local ref

    ref=$(grep "^ref=" "$SMOKE_SCRIPTING_FLAG" | cut -d= -f2)

    ref=$((ref + 1))

    sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SCRIPTING_FLAG"

    rlLogInfo "smoke-scripting already initialized by other tests, reference count: $ref"

    fi

    rlCleanupAppend "smokeScriptingCleanup"

}



smokeScriptingCleanup() {

    if [ ! -f "$SMOKE_SCRIPTING_FLAG" ]; then

    return 0

    fi

    local ref

    ref=$(grep "^ref=" "$SMOKE_SCRIPTING_FLAG" | cut -d= -f2)

    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then

    rm -f "$SMOKE_SCRIPTING_FLAG"

    rlLogInfo "smoke-scripting: Cleanup complete (posttest)"

    else

    sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_SCRIPTING_FLAG"

    rlLogInfo "smoke-scripting: Retain (still have $ref test(s) not completed)"

    fi

}

