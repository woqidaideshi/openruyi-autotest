# library-prefix = smoke_network

#

# Smoke network suite-level shared library

# Uses flag-file + reference counting to ensure the category's

# dependency packages are verified only ONCE across all test cases.

# Most smoke dependencies (iputils curl wget openssh-clients iproute2) are always present on the system;

# this lib verifies their existence rather than installing.

#

# Usage in each test file:

#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories



SMOKE_NETWORK_FLAG="/tmp/.beakerlib_smoke_network_suite"



smokeNetworkSetup() {

 if [ ! -f "$SMOKE_NETWORK_FLAG" ]; then

 echo "installed=0" > "$SMOKE_NETWORK_FLAG"

 echo "ref=1" >> "$SMOKE_NETWORK_FLAG"

 rlLogInfo "smoke-network: coreDependenciesalreadyconfirmavailable"

 else

 local ref

 ref=$(grep "^ref=" "$SMOKE_NETWORK_FLAG" | cut -d= -f2)

 ref=$((ref + 1))

 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_NETWORK_FLAG"

 rlLogInfo "smoke-network already initialized by other tests, reference count: $ref"

 fi

 rlCleanupAppend "smokeNetworkCleanup"

}



smokeNetworkCleanup() {

 if [ ! -f "$SMOKE_NETWORK_FLAG" ]; then

 return 0

 fi

 local ref

 ref=$(grep "^ref=" "$SMOKE_NETWORK_FLAG" | cut -d= -f2)

 ref=$((ref - 1))

 if [ "$ref" -le 0 ]; then

 rm -f "$SMOKE_NETWORK_FLAG"

 rlLogInfo "smoke-network: Cleanup complete (posttest)"

 else

 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_NETWORK_FLAG"

 rlLogInfo "smoke-network: Retain (still have $ref test(s) not completed)"

 fi

}

