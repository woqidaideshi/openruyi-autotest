# library-prefix = perf_iozone

#

# IOzone filesystem benchmark suite-level shared library

# Installs iozone, provides result parsing helpers.

#

# IOzone measures filesystem I/O performance with various

# access patterns: sequential/random read/write, etc.

#

# Key parameters:

# -a Auto mode (tests record sizes 4k-16M, files 64k-512M)

# -c Include close() in timing

# -I Direct I/O (bypass page cache)

# -s SIZE File size (e.g., 128m, 1g)

# -r SIZE Record size (e.g., 4k, 16m)

# -f FILE Test file path

#

# Result: throughput in kBytes/sec for each operation type

#

# Usage:. "$(dirname "$0")/../lib.sh"



IOZONE_FLAG="/tmp/.beakerlib_iozone_suite"



iozoneSetup() {

    if [ ! -f "$IOZONE_FLAG" ]; then

    if ! rpm -q iozone 2>/dev/null; then

    echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y iozone 2>/dev/null

    if ! rpm -q iozone 2>/dev/null; then

    rlLogWarning "iozone failed"

    echo "installed=0" > "$IOZONE_FLAG"

    else

    echo "installed=1" > "$IOZONE_FLAG"

    rlLogInfo "already iozone"

    fi

    else

    echo "installed=0" > "$IOZONE_FLAG"

    rlLogInfo "iozone already exists"

    fi

    echo "ref=1" >> "$IOZONE_FLAG"

    else

    local ref

    ref=$(grep "^ref=" "$IOZONE_FLAG" | cut -d= -f2)

    ref=$((ref + 1))

    sed -i "s/^ref=.*/ref=$ref/" "$IOZONE_FLAG"

    rlLogInfo "iozone reference count: $ref"

    fi

    rlCleanupAppend "iozoneCleanup"

}



iozoneCleanup() {

    if [ ! -f "$IOZONE_FLAG" ]; then return 0; fi

    local ref

    ref=$(grep "^ref=" "$IOZONE_FLAG" | cut -d= -f2)

    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then

    if grep -q "^installed=1" "$IOZONE_FLAG"; then

    echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y iozone 2>/dev/null || true

    fi

    rm -f "$IOZONE_FLAG"

    else

    sed -i "s/^ref=.*/ref=$ref/" "$IOZONE_FLAG"

    fi

}



# Parse iozone output and extract key metrics

# Usage: _iozoneParseOutput <logfile>

_iozoneParseOutput() {

    local log="$1"

    if [ ! -f "$log" ]; then return 1; fi



    echo "=== IOzone resultresolve ==="

    # Extract the data line (contains throughput values)

    grep -E '^\s+[0-9]+\s+[0-9]+' "$log" | while read -r line; do

    # Parse: kB reclen write rewrite read reread random_read random_write bkwd_read record_rewrite stride_read fwrite frewrite fread freread

    local kb reclen write rewrite read_val reread rread rwrite bkwd rec_rewrite stride fwrite frewrite fread freread

    read -r kb reclen write rewrite read_val reread rread rwrite bkwd rec_rewrite stride fwrite frewrite fread freread <<< "$line"



    echo ""

    echo "filesize: ${kb} KB, recordsize: ${reclen} KB"

    echo " Write: ${write} KB/s"

    echo " Re-write: ${rewrite} KB/s"

    echo " Read: ${read_val} KB/s"

    echo " Re-read: ${reread} KB/s"

    echo " Random Read: ${rread} KB/s"

    echo " Random Write: ${rwrite} KB/s"



    # Calculate geometric mean of the key metrics

    if [ -n "$write" ] && [ "$write" != "0" ]; then

    local geo

    geo=$(awk "BEGIN { printf \"%.0f\", ($write * $rewrite * ${read_val} * $reread * $rread * $rwrite) ^ (1/6) }" 2>/dev/null)

    echo " Geometric Mean (6 ops): ${geo} KB/s"

    fi

    done

    echo "=== resolve ==="

}

