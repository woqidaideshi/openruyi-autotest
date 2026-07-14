#!/bin/bash


# ============================================================


# hw_check.sh -- Hardware environment check & multi-server remote execution library


# ============================================================


#


# within local provision mode:


# 1. Check if current environment meets hardware requirements declared in test cases


# 2. Execute commands remotely on multiple servers


#


# Dependencies:


# - topology.env (repository root directory), by Plan environment-file loaded


# - sshpass (can be optional, for password-auth remote execution)


#


# Usage:


#. "$(dirname "$0")/../../lib/hw_check.sh"


#


# hwVerify # Comprehensive check extra-hardware-require all fields


# hwServerVerify # Check server count only


# hwCpuCheck # Check CPU


# hwMemCheck # Checkmemory


# hwDiskCheck # Checkdisk count


# hwRunOnServer 1 "hostname"


# hwGetServerInfo 1 host


# ============================================================





# ── Internal:from main.fmf Read field value ──────────────────────────


_hwFmfGet() {


 local section="$1" # e.g. "extra-hardware-require"


 local key="$2" # e.g. "server"


 local file="${3:-main.fmf}"





 # resolve extra-hardware-require key: value


 # Supported format:


 # extra-hardware-require:


 # server: 2


 # cpu: ">= 4"


 awk -v sec="$section" -v k="$key" '


 $0 ~ "^"sec":" { in_section=1; next }


 in_section && /^[[:space:]]+[a-z]/ {


 if ($1 == k":") {


 # output key post all value (e.g. ">= 4" "8 GiB")


 $1 = ""


 sub(/^[[:space:]]+/, "")


 gsub(/"/, "")


 print


 exit


 }


 }


 in_section && /^[^[:space:]]/ { exit }


 ' "$file"


}





# ── Internal:Parse comparison operator ──────────────────────────────────


# return: op (operator)actual (actual value)


_hwParseOp() {


 local raw="$1"


 if [[ "$raw" =~ ^(\>=|\<=|!=|>|<|=) ]]; then


 op="${BASH_REMATCH[1]}"


 actual="${raw#$op}"


 # stripmultiremainingspacesandquotes


 actual=$(echo "$actual" | tr -d '"'"'" | xargs)


 else


 op="="


 actual=$(echo "$raw" | tr -d '"'"'" | xargs)


 fi


 echo "$op|$actual"


}





# ── Internal:Generic comparison function ────────────────────────────────────


_hwCompare() {


 local have="$1" # actual value


 local need_raw="$2" # raw requirement string (e.g. ">= 4")


 local type="${3:-int}" # int or str





 local parsed=$(_hwParseOp "$need_raw")


 local op="${parsed%%|*}"


 local val="${parsed##*|}"





 case "$type" in


 int)


 case "$op" in


 "=") [ "$have" -eq "$val" ];;


 "!=") [ "$have" -ne "$val" ];;


 ">") [ "$have" -gt "$val" ];;


 ">=") [ "$have" -ge "$val" ];;


 "<") [ "$have" -lt "$val" ];;


 "<=") [ "$have" -le "$val" ];;


 *) return 1;;


 esac


;;


 str)


 case "$op" in


 "=") [ "$have" = "$val" ];;


 "!=") [ "$have" != "$val" ];;


 *) return 1;;


 esac


;;


 esac


}





# ════════════════════════════════════════════════════════════


# Public functions


# ════════════════════════════════════════════════════════════





# ── hwGetServerInfo:Get server connection info ─────────────────────


# parameter: <index: 1~N> <field: host|port|user|password>


# Example: host=$(hwGetServerInfo 1 host)


hwGetServerInfo() {


 local idx="$1"


 local field="$2"


 local var="TEST_SERVER_${idx}_${field^^}"


 echo "${!var}"


}





# ── hwRunOnServer:Execute command on specified server ──────────────────


# parameter: <index: 1~N> <command>


# return: commandexit code


# Example: hwRunOnServer 2 "df -h"


hwRunOnServer() {


 local idx="$1"; shift


 local host=$(hwGetServerInfo "$idx" host)


 local port=$(hwGetServerInfo "$idx" port)


 local user=$(hwGetServerInfo "$idx" user)


 local pass=$(hwGetServerInfo "$idx" password)





 port="${port:-22}"


 user="${user:-root}"





 # e.g.if localhost, Execute


 if [ "$host" = "localhost" ] || [ "$host" = "127.0.0.1" ] || [ "$host" = "$(hostname -I 2>/dev/null | awk '{print $1}')" ]; then


 rlLogInfo "[local@$idx] $*"


 eval "$@"


 return $?


 fi





 # e.g.ifusernois root, passed sudo escalate privileges


 if [ "$user" != "root" ]; then


 rlLogInfo "[$user@$host:$port] (sudo) $*"


 # willcommandparametersecurityescapepostpassed sudo Execute


 local remote_cmd


 remote_cmd=$(printf '%q ' "$@")


 if [ -n "$pass" ] && command -v sshpass >/dev/null 2>&1; then


 sshpass -p "$pass" ssh -o StrictHostKeyChecking=no \


 -o ConnectTimeout=10 -p "$port" "${user}@${host}" \


 "echo '$pass' | sudo -S -- sh -c $remote_cmd"


 else


 ssh -o StrictHostKeyChecking=no \


 -o ConnectTimeout=10 -p "$port" "${user}@${host}" \


 "sudo -- sh -c $remote_cmd"


 fi


 else


 rlLogInfo "[$user@$host:$port] $*"


 if [ -n "$pass" ] && command -v sshpass >/dev/null 2>&1; then


 sshpass -p "$pass" ssh -o StrictHostKeyChecking=no \


 -o ConnectTimeout=10 -p "$port" "${user}@${host}" "$@"


 else


 ssh -o StrictHostKeyChecking=no \


 -o ConnectTimeout=10 -p "$port" "${user}@${host}" "$@"


 fi


 fi


}





# ── hwServerVerify:Check if server count meets requirements ──────────────


# read main.fmf in extra-hardware-require.server


# and topology.env in TEST_SERVER_COUNT compare


# noif metexit code 0 (tmt treated asis skip)


hwServerVerify() {


 local have=${TEST_SERVER_COUNT:-1}


 local need


 need=$(_hwFmfGet "extra-hardware-require" "server" "${1:-main.fmf}")





 [ -z "$need" ] && return 0





 if [ "$have" -lt "$need" ]; then


 echo "SKIP: need $need servers, but TEST_SERVER_COUNT=$have"


 rlLogWarning "Environmentnomeets: needs $need server, actualonlyhas $have "


 rlLogWarning "Pleasein topology.env inconfigurationmoremultiserverpostretry"


 exit 0


 fi


 rlLogInfo "hw: servers OK ($have >= $need)"


 return 0


}





# ── hwCpuCheck:check CPU corecount ────────────────────────────


hwCpuCheck() {


 local need


 need=$(_hwFmfGet "extra-hardware-require" "cpu" "${1:-main.fmf}")


 [ -z "$need" ] && return 0





 local have=$(nproc)





 if ! _hwCompare "$have" "$need" int; then


 echo "SKIP: need cpu $need, have $have cores"


 rlLogWarning "Environmentnomeets: CPU needs $need, actual $(nproc) core"


 exit 0


 fi


 rlLogInfo "hw: CPU OK (have $have, need $need)"


 return 0


}





# ── hwMemCheck:checkmemorysize (GB)───────────────────────────


hwMemCheck() {


 local need


 need=$(_hwFmfGet "extra-hardware-require" "memory" "${1:-main.fmf}")


 [ -z "$need" ] && return 0





 # getavailablememory (GB), with free command


 local have=$(free -g | awk '/^Mem:/{print $7}')


 [ -z "$have" ] && have=$(free -g | awk '/^Mem:/{print $2}')





 # e.g.if need incontains GiB/GB single, extractnumber


 local need_num=$(echo "$need" | grep -oP '[\d.]+' | head -1)





 if [ -z "$need_num" ]; then


 rlLogWarning "hw: Unable toresolvememoryneed '$need', skipcheck"


 return 0


 fi





 if [ "$have" -lt "$need_num" ]; then


 echo "SKIP: need memory $need, have ${have}G"


 rlLogWarning "Environmentnomeets: memoryneeds $need, actual ${have}G"


 exit 0


 fi


 rlLogInfo "hw: Memory OK (have ${have}G, need $need)"


 return 0


}





# ── hwDiskCheck:checkdisk count ───────────────────────────────


hwDiskCheck() {


 local need


 need=$(_hwFmfGet "extra-hardware-require" "disk" "${1:-main.fmf}")


 [ -z "$need" ] && return 0





 local have=$(lsblk -nd 2>/dev/null | wc -l)





 if ! _hwCompare "$have" "$need" int; then


 echo "SKIP: need disk count $need, have $have disks"


 rlLogWarning "Environmentnomeets: disk needs $need block, actual $have block"


 exit 0


 fi


 rlLogInfo "hw: Disk OK (have $have, need $need)"


 return 0


}





# ── hwNetCheck:checkcount ────────────────────────────────


hwNetCheck() {


 local need


 need=$(_hwFmfGet "extra-hardware-require" "net" "${1:-main.fmf}")


 [ -z "$need" ] && return 0





 # countphysical NICscount (exclude lo loopbackInterface)


 local have=$(ip -o link show 2>/dev/null | grep -v 'lo' | grep -c'state UP')


 [ -z "$have" ] && have=0





 if ! _hwCompare "$have" "$need" int; then


 echo "SKIP: need net count $need, have $have interfaces"


 rlLogWarning "Environmentnomeets: NICs need $need, actual $have "


 exit 0


 fi


 rlLogInfo "hw: Net OK (have $have, need $need)"


 return 0


}





# ── hwVerify:Comprehensive checkall extra-hardware-require field ───────────


# recommendedin rlPhaseStartTest at beginheadercallwith


hwVerify() {


 local fmf="${1:-main.fmf}"





 # checkwhetherdeclared extra-hardware-require


 if ! grep -q "^extra-hardware-require:" "$fmf" 2>/dev/null; then


 return 0 # notdeclared, noneedcheck


 fi





 rlLogInfo "===== Hardware environment check ====="


 hwServerVerify "$fmf"


 hwCpuCheck "$fmf"


 hwMemCheck "$fmf"


 hwDiskCheck "$fmf"


 hwNetCheck "$fmf"


 rlLogInfo "===== Hardware environment checkpassed ====="


 return 0


}


