#!/usr/bin/env bash
set -e
#set -euo pipefail

# This is MacOS only
# JAVA_HOME=$(/usr/libexec/java_home -v1.8) # This is MacOS only
# CIQ_PATH="$(cat ${HOME}/Library/Application\ Support/Garmin/ConnectIQ/current-sdk.cfg)/bin"

# Linux Environment
CIQ_PATH="$(cat ${HOME}/.Garmin/ConnectIQ/current-sdk.cfg)/bin"
DEVELOPER_KEY_PATH="${HOME}/.Garmin/ConnectIQ/connectIQ_developer_key"

# Common Environment
RDIR="$(dirname "${0}")"
export PATH="${PATH}:${CIQ_PATH}"

MINSDKVERSION="$(grep -oE 'minSdkVersion="[^"]*"' "${RDIR}/manifest.xml" | grep -oE '"[^"]*"' | tr -d '"')"
DEVICES="$(grep -F '<iq:product id="' "${RDIR}/manifest.xml" | grep -oE '"[^"]*"' | tr -d '"')"
NB_DEVICES="$(printf "${DEVICES}\n" | wc -l)"
CURRENT_DEVICE="$(printf "${DEVICES}\n" | head -n $(( 1 + ${RANDOM} % ${NB_DEVICES} )) | tail -n 1)"


CURRENT_OPTS=
function _help() {
    printf "${0} [<options> command] ... [<options> command]
  Commands:
    help     Display this help message
    clean    Remove bin directory
    doc      Generate documentation
    pack     Build the datafield as a Connect IQ package
    build    Build the datafield for a device
    run      Run in the simulator
    debug    Debug with the simulator
    simu     Start the simulator

  The list of the available device for the datafield is:
"
    printf "${DEVICES}" | xargs -L 5 | column -t
    printf "\n"
}


function _simu() {
    # Start simulator only if not already running, and put it in the background
    if ! pgrep -x simulator > /dev/null 2>&1 ; then
        "${CIQ_PATH}/simulator" &
        # small delay so it’s ready to accept monkeydo
        sleep 2
    fi
}

function _clean() {
    printf " Clean / Options: ${CURRENT_OPTS}\n"
    pkill simulator || true
    rm -rf "${RDIR}/bin"
}

function _doc() {
    printf " Doc   / Options: ${CURRENT_OPTS}\n"
    monkeydoc ${CURRENT_OPTS} \
        -Wall \
        --api-mir "${CIQ_PATH}/api.mir" \
        --output-path "${RDIR}/bin/doc/" \
        "${RDIR}/source/"*".mc"
}

function _pack() {
    printf " Pack  / Options: ${CURRENT_OPTS}\n"
    monkeyc ${CURRENT_OPTS} \
        --release \
        --package-app \
        --warn \
        --typecheck   3 \
        --api-level   "${MINSDKVERSION}" \
        --jungles     "${RDIR}/monkey.jungle;${RDIR}/barrels.jungle" \
        --output      "${RDIR}/bin/ActiveLookDataField.iq" \
        --private-key "${DEVELOPER_KEY_PATH}"
}

function _build() {
    printf " Build / Device: ${CURRENT_DEVICE} / Options: ${CURRENT_OPTS}\n"
    monkeyc ${CURRENT_OPTS} \
        --warn \
        --typecheck   0 \
        --device      "${CURRENT_DEVICE}" \
        --jungles     "${RDIR}/monkey.jungle;${RDIR}/barrels.jungle" \
        --output      "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" \
        --private-key "${DEVELOPER_KEY_PATH}"
}

function _run() {
    printf " Run   / Device: ${CURRENT_DEVICE} / Options: ${CURRENT_OPTS}\n"
    _simu
    if ! [ -f "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" ] ; then
        _build
    fi
    monkeydo ${CURRENT_OPTS} \
        "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" \
        ${CURRENT_DEVICE}
}

function _debug() {
    printf " Debug / Device: ${CURRENT_DEVICE} / Options: ${CURRENT_OPTS}\n"
    _simu
    if ! [ -f "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" ] ; then
        _build
    fi
    mdd ${CURRENT_OPTS} \
        --device      "${CURRENT_DEVICE}" \
        --executable  "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" \
        --debug-xml   "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg.debug.xml"
}

function _device() {
    CURRENT_DEVICE="${1}"
    if ! printf "${DEVICES}" | grep -Fxq "${CURRENT_DEVICE}" ; then
        _help
        exit 1
    fi
}

# If no arguments, show help
if [ $# -eq 0 ]; then
    _help
    exit 0
fi

# Parse arguments and run commands
while [ ${#} -gt 0 ] ; do
    case "${1}" in
        help)  shift ; _help  ; CURRENT_OPTS= ;;
        clean) shift ; _clean ; CURRENT_OPTS= ;;
        doc)   shift ; _doc   ; CURRENT_OPTS= ;;
        pack)  shift ; _pack  ; CURRENT_OPTS= ;;
        build) shift ; _build ; CURRENT_OPTS= ;;
        run)   shift ; _run   ; CURRENT_OPTS= ;;
        debug) shift ; _debug ; CURRENT_OPTS= ;;
        simu)  shift ; _simu  ; CURRENT_OPTS= ;;
        --device)        shift ; _device "${1}" ; shift ;;
        --random-device) shift ; _device "${CURRENT_DEVICE}" ;;
        --) shift ; CURRENT_OPTS= ;;
        *) CURRENT_OPTS="${CURRENT_OPTS} ${1}" ; shift ;;
    esac
done

exit 0
