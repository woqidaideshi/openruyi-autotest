# library-prefix = pyproject_rpm_macros

#

# pyproject-rpm-macros suite-level shared library

# Uses flag-file + reference counting to ensure the package

# is installed only ONCE and uninstalled only ONCE across all

# test cases.



PKG_FLAG="/tmp/.beakerlib_pyproject_rpm_macros_suite"



pyprojectRpmMacrosSetup() {

    if [ ! -f "$PKG_FLAG" ]; then

    if ! rpm -q pyproject-rpm-macros 2>/dev/null; then

    echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y pyproject-rpm-macros 2>/dev/null

    echo "installed=1" > "$PKG_FLAG"

    rlLogInfo "already pyproject-rpm-macros soft ()"

    else

    echo "installed=0" > "$PKG_FLAG"

    rlLogInfo "pyproject-rpm-macros softalready exists"

    fi

    echo "ref=1" >> "$PKG_FLAG"

    else

    local ref

    ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)

    ref=$((ref + 1))

    sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"

    rlLogInfo "pyproject-rpm-macros alreadybyothertest, reference count: $ref"

    fi

    rlCleanupAppend "pyprojectRpmMacrosCleanup"

}



pyprojectRpmMacrosCleanup() {

    if [ ! -f "$PKG_FLAG" ]; then

    return 0

    fi

    local ref

    ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)

    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then

    if grep -q "^installed=1" "$PKG_FLAG"; then

    echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y pyproject-rpm-macros 2>/dev/null || true

    rlLogInfo "already pyproject-rpm-macros soft (posttest)"

    fi

    rm -f "$PKG_FLAG"

    else

    sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"

    rlLogInfo "pyproject-rpm-macros Retain (still have $ref test(s) not completed)"

    fi

}

