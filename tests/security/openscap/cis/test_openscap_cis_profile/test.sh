#!/bin/bash
# Security test: openscap cis - profile verification
# Self-contained: checks CIS profile exists in data stream

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname $0)/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        cisSetup
    rlPhaseEnd

    rlPhaseStartTest "CIS Profile Verification"
        if [ ! -f "$CIS_DS" ]; then
            rlFail "Data stream not found"
        else
            local out=/tmp/cis_profile_$$
            oscap info "$CIS_DS" 2>&1 | tee $out
            if grep -q "$CIS_PROFILE" "$out"; then
                local count=$(grep -c 'Id: xccdf_org.ssgproject.content_profile_' "$out")
                rlPass "CIS profile $CIS_PROFILE found ($count profiles)"
            else
                rlFail "CIS profile not found"
            fi
            rm -f $out
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd