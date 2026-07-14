#!/bin/bash

# Functional test: compiler - yarpgen - Generateprogramandwith G++/Clang compile

# with yarpgen Generate random C++ program, Using respectively g++ and clang compile

# verify: Compile succeeded, Output is ELF, Check compile warnings/error



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



YARPGEN_BIN="/tmp/yarpgen/build/yarpgen"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    yarpgenSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary directory"

 

    if [ ! -x "$YARPGEN_BIN" ]; then

    rlFail "yarpgen executablenoavailable"

    else

    # Generate random C++ program

    rlRun "$YARPGEN_BIN 2>&1" 0 "Generate random C++ program"

    for f in init.h func.cpp driver.cpp; do

    rlAssertExists "$f"

    done

 

    # displayGeneratelinescount

    rlRun "wc -l init.h func.cpp driver.cpp" 0 "Generatelinescountcount"

    fi

    rlPhaseEnd



    rlPhaseStartTest "G++ compile"

    if [ ! -f "func.cpp" ]; then

    rlFail "filedoes not exist, skip"

    else

    # G++ -O0

    rlRun "g++ -fPIC func.cpp driver.cpp -o yarpgen_gxx_O0 -O0 2>/tmp/yarpgen_gxx_O0_err.txt" 0 "G++ -O0 compile"

    if [ -x./yarpgen_gxx_O0 ]; then

    rlRun "file./yarpgen_gxx_O0 | grep -i elf" 0 "G++ -O0 Output is ELF"

    local warn_O0

    warn_O0=$(grep -c "warning:" /tmp/yarpgen_gxx_O0_err.txt 2>/dev/null || echo 0)

    rlLogInfo "G++ -O0 warning count: $warn_O0"

    fi

 

    # G++ -O2

    rlRun "g++ -fPIC func.cpp driver.cpp -o yarpgen_gxx_O2 -O2 2>/tmp/yarpgen_gxx_O2_err.txt" 0 "G++ -O2 compile"

    if [ -x./yarpgen_gxx_O2 ]; then

    rlPass "G++ -O2 Compile succeeded"

    local warn_O2

    warn_O2=$(grep -c "warning:" /tmp/yarpgen_gxx_O2_err.txt 2>/dev/null || echo 0)

    rlLogInfo "G++ -O2 warning count: $warn_O2"

 

    # displayoptimizationwarningdiff

    rlRun "grep 'warning:' /tmp/yarpgen_gxx_O2_err.txt | head -10" 0 "G++ -O2 warning (before 10)"

    fi

 

    # G++ -O3

    rlRun "g++ -fPIC func.cpp driver.cpp -o yarpgen_gxx_O3 -O3 2>/tmp/yarpgen_gxx_O3_err.txt" 0 "G++ -O3 compile"

    if [ -x./yarpgen_gxx_O3 ]; then

    rlPass "G++ -O3 Compile succeeded"

    local warn_O3

    warn_O3=$(grep -c "warning:" /tmp/yarpgen_gxx_O3_err.txt 2>/dev/null || echo 0)

    rlLogInfo "G++ -O3 warning count: $warn_O3"

    fi

    fi

    rlPhaseEnd



    rlPhaseStartTest "Clang compile"

    if [ ! -f "func.cpp" ]; then

    rlFail "filedoes not exist, skip"

    else

    # Clang -O0

    rlRun "clang++ -fPIC func.cpp driver.cpp -o yarpgen_clang_O0 -O0 2>/tmp/yarpgen_clang_O0_err.txt" 0 "Clang -O0 compile"

    if [ -x./yarpgen_clang_O0 ]; then

    rlRun "file./yarpgen_clang_O0 | grep -i elf" 0 "Clang -O0 Output is ELF"

    fi

 

    # Clang -O2

    rlRun "clang++ -fPIC func.cpp driver.cpp -o yarpgen_clang_O2 -O2 2>/tmp/yarpgen_clang_O2_err.txt" 0 "Clang -O2 compile"

    if [ -x./yarpgen_clang_O2 ]; then

    rlPass "Clang -O2 Compile succeeded"

    local warn_O2

    warn_O2=$(grep -c "warning:" /tmp/yarpgen_clang_O2_err.txt 2>/dev/null || echo 0)

    rlLogInfo "Clang -O2 warning count: $warn_O2"

    rlRun "grep 'warning:' /tmp/yarpgen_clang_O2_err.txt | head -10" 0 "Clang -O2 warning (before 10)"

    fi

 

    # Clang -O3

    rlRun "clang++ -fPIC func.cpp driver.cpp -o yarpgen_clang_O3 -O3 2>/tmp/yarpgen_clang_O3_err.txt" 0 "Clang -O3 compile"

    if [ -x./yarpgen_clang_O3 ]; then

    rlPass "Clang -O3 Compile succeeded"

    local warn_O3

    warn_O3=$(grep -c "warning:" /tmp/yarpgen_clang_O3_err.txt 2>/dev/null || echo 0)

    rlLogInfo "Clang -O3 warning count: $warn_O3"

    fi

    fi

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 "Leave temporary directory"

    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"

    rm -f /tmp/yarpgen_{gxx,clang}_O?_err.txt

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd

