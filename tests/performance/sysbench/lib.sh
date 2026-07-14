# library-prefix = perf_sysbench

#

# sysbench multi-threaded benchmark suite-level shared library

# Measures OS performance: CPU, memory, threads, mutex, file I/O.

#

# Key metrics (from Testing-Guide):

# CPU: events/sec (higher=better)

# Memory: MiB/sec (higher=better)

# Threads: eps + 95% latency + fairness (avg/stddev)

# Mutex: lock throughput (threads * locks / time)

# FileIO: MiB/sec throughput

#

# Usage:. "$(dirname "$0")/../lib.sh"



SYSBENCH_FLAG="/tmp/.beakerlib_sysbench_suite"



sysbenchSetup() {

 if [ ! -f "$SYSBENCH_FLAG" ]; then

 if ! rpm -q sysbench 2>/dev/null; then

 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y sysbench 2>/dev/null

 echo "installed=1" > "$SYSBENCH_FLAG"

 rlLogInfo "already sysbench"

 else

 echo "installed=0" > "$SYSBENCH_FLAG"

 fi

 echo "ref=1" >> "$SYSBENCH_FLAG"

 else

 local ref

 ref=$(grep "^ref=" "$SYSBENCH_FLAG" | cut -d= -f2)

 ref=$((ref + 1))

 sed -i "s/^ref=.*/ref=$ref/" "$SYSBENCH_FLAG"

 fi

 rlCleanupAppend "sysbenchCleanup"

}



sysbenchCleanup() {

 if [ ! -f "$SYSBENCH_FLAG" ]; then return 0; fi

 local ref

 ref=$(grep "^ref=" "$SYSBENCH_FLAG" | cut -d= -f2)

 ref=$((ref - 1))

 if [ "$ref" -le 0 ]; then

 grep -q "^installed=1" "$SYSBENCH_FLAG" && echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y sysbench 2>/dev/null || true

 rm -f "$SYSBENCH_FLAG"

 else

 sed -i "s/^ref=.*/ref=$ref/" "$SYSBENCH_FLAG"

 fi

}



# Parse sysbench output for key metrics

_sysbenchParse() {

 local log="$1"

 [ ! -f "$log" ] && return 1

 echo "--- sysbench result ---"

 grep -E "total time:|total number of events|events per second|avg:|95th percentile|events.*avg/stddev|MiB/sec|transferred" "$log" | head -10

 echo "---"

}

