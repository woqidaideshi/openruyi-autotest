# library-prefix = re2c

#

# re2c suite-level shared library

# Uses flag-file + reference counting to ensure the package

# is installed only ONCE and uninstalled only ONCE across all

# test cases.



PKG_FLAG="/tmp/.beakerlib_re2c_suite"



re2cSetup() {

 if [ ! -f "$PKG_FLAG" ]; then

 if ! rpm -q re2c 2>/dev/null; then

 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y re2c 2>/dev/null

 echo "installed=1" > "$PKG_FLAG"

 rlLogInfo "already re2c soft ()"

 else

 echo "installed=0" > "$PKG_FLAG"

 rlLogInfo "re2c softalready exists"

 fi

 echo "ref=1" >> "$PKG_FLAG"

 else

 local ref

 ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)

 ref=$((ref + 1))

 sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"

 rlLogInfo "re2c alreadybyothertest, reference count: $ref"

 fi

 rlCleanupAppend "re2cCleanup"

}



re2cCleanup() {

 if [ ! -f "$PKG_FLAG" ]; then

 return 0

 fi

 local ref

 ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)

 ref=$((ref - 1))

 if [ "$ref" -le 0 ]; then

 if grep -q "^installed=1" "$PKG_FLAG"; then

 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y re2c 2>/dev/null || true

 rlLogInfo "already re2c soft (posttest)"

 fi

 rm -f "$PKG_FLAG"

 else

 sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"

 rlLogInfo "re2c Retain (still have $ref test(s) not completed)"

 fi

}

