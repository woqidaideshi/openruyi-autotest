# library-prefix = nss_wrapper
#
# nss_wrapper suite-level shared library
# Uses flag-file + reference counting to ensure the package
# is installed only ONCE and uninstalled only ONCE across all
# test cases.

PKG_FLAG="/tmp/.beakerlib_nss_wrapper_suite"

nssWrapperSetup() {
 if [ ! -f "$PKG_FLAG" ]; then
 if ! rpm -q nss_wrapper 2>/dev/null; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y nss_wrapper 2>/dev/null
 echo "installed=1" > "$PKG_FLAG"
 rlLogInfo "already nss_wrapper soft（）"
 else
 echo "installed=0" > "$PKG_FLAG"
 rlLogInfo "nss_wrapper softalready exists"
 fi
 echo "ref=1" >> "$PKG_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
 rlLogInfo "nss_wrapper alreadybyothertest，reference count: $ref"
 fi
 rlCleanupAppend "nssWrapperCleanup"
}

nssWrapperCleanup() {
 if [ ! -f "$PKG_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 if grep -q "^installed=1" "$PKG_FLAG"; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y nss_wrapper 2>/dev/null || true
 rlLogInfo "already nss_wrapper soft（posttest）"
 fi
 rm -f "$PKG_FLAG"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
 rlLogInfo "nss_wrapper Retain（still have $ref test(s) not completed）"
 fi
}
