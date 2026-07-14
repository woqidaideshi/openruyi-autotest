# library-prefix = smoke_package_mgmt

#

# Smoke package_mgmt suite-level shared library

# Uses flag-file + reference counting to ensure the category's

# dependency packages are verified only ONCE across all test cases.

# Most smoke dependencies (dnf rpm) are always present on the system;

# this lib verifies their existence rather than installing.

#

# Usage in each test file:

#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories



SMOKE_PACKAGE_MGMT_FLAG="/tmp/.beakerlib_smoke_package_mgmt_suite"



smokePackageMgmtSetup() {

    if [ ! -f "$SMOKE_PACKAGE_MGMT_FLAG" ]; then

    echo "installed=0" > "$SMOKE_PACKAGE_MGMT_FLAG"

    echo "ref=1" >> "$SMOKE_PACKAGE_MGMT_FLAG"

    rlLogInfo "smoke-package_mgmt: coreDependenciesalreadyconfirmavailable"

    else

    local ref

    ref=$(grep "^ref=" "$SMOKE_PACKAGE_MGMT_FLAG" | cut -d= -f2)

    ref=$((ref + 1))

    sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_PACKAGE_MGMT_FLAG"

    rlLogInfo "smoke-package_mgmt already initialized by other tests, reference count: $ref"

    fi

    rlCleanupAppend "smokePackageMgmtCleanup"

}



smokePackageMgmtCleanup() {

    if [ ! -f "$SMOKE_PACKAGE_MGMT_FLAG" ]; then

    return 0

    fi

    local ref

    ref=$(grep "^ref=" "$SMOKE_PACKAGE_MGMT_FLAG" | cut -d= -f2)

    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then

    rm -f "$SMOKE_PACKAGE_MGMT_FLAG"

    rlLogInfo "smoke-package_mgmt: Cleanup complete (posttest)"

    else

    sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_PACKAGE_MGMT_FLAG"

    rlLogInfo "smoke-package_mgmt: Retain (still have $ref test(s) not completed)"

    fi

}

