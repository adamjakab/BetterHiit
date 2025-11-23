#!/usr/bin/env bash
set -e

# Environment Specific Variables
CIQ_PATH="$(cat "${HOME}/.Garmin/ConnectIQ/current-sdk.cfg")/bin"
DEVELOPER_KEY_PATH="${HOME}/.Garmin/ConnectIQ/connectIQ_developer_key"

# Script directory
RDIR="$(dirname "${0}")"
export PATH="${PATH}:${CIQ_PATH}"

# Parse manifest.xml
MINSDKVERSION="$(grep -oE 'minSdkVersion="[^"]*"' "${RDIR}/manifest.xml" | grep -oE '"[^"]*"' | tr -d '"')"
DEVICES="$(grep -F '<iq:product id="' "${RDIR}/manifest.xml" | grep -oE '"[^"]*"' | tr -d '"')"
NB_DEVICES="$(printf "%s\n" "${DEVICES}" | wc -l)"
CURRENT_DEVICE="$(printf "%s\n" "${DEVICES}" | head -n $(( 1 + RANDOM % NB_DEVICES )) | tail -n 1)"

CURRENT_OPTS=

function _help() {
    cat << EOF
Usage: ${0} [<options> command] ... [<options> command]

Commands:
    help     Display this help message
    clean    Remove bin directory
    doc      Generate documentation
    pack     Build the datafield as a Connect IQ package
    build    Build the datafield for a device
    run      Run in the simulator
    debug    Debug with the simulator
    simu     Start the simulator

Available devices:
EOF
    printf "%s" "${DEVICES}" | xargs -L 5 | column -t
    echo
}


function _simu() {
    # Start simulator only if not already running
    if ! pgrep -x simulator > /dev/null 2>&1; then
        echo "Starting simulator..."
        "${CIQ_PATH}/simulator" &
        sleep 2  # Wait for simulator to be ready
        echo "Simulator started."
    fi
}

function _clean() {
    echo "Cleaning build directory..."
    pkill simulator 2>/dev/null || true
    rm -rf "${RDIR}/bin"
    echo "Build directory cleaned."
}

function _doc() {
    echo "Generating documentation..."
    monkeydoc ${CURRENT_OPTS} \
        -Wall \
        --api-mir "${CIQ_PATH}/api.mir" \
        --output-path "${RDIR}/bin/doc/" \
        "${RDIR}/source/"*.mc
    echo "Documentation generated at ${RDIR}/bin/doc/"
}

function _pack() {
    echo "Packaging application..."
    monkeyc ${CURRENT_OPTS} \
        --release \
        --package-app \
        --warn \
        --typecheck 3 \
        --api-level "${MINSDKVERSION}" \
        --jungles "${RDIR}/monkey.jungle;${RDIR}/barrels.jungle" \
        --output "${RDIR}/bin/ActiveLookDataField.iq" \
        --private-key "${DEVELOPER_KEY_PATH}"
    echo "Application packaged at ${RDIR}/bin/ActiveLookDataField.iq"
}

function _build() {
    echo "Building for device: ${CURRENT_DEVICE}"
    monkeyc ${CURRENT_OPTS} \
        --warn \
        --typecheck 0 \
        --device "${CURRENT_DEVICE}" \
        --jungles "${RDIR}/monkey.jungle;${RDIR}/barrels.jungle" \
        --output "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" \
        --private-key "${DEVELOPER_KEY_PATH}"
    echo "Build completed: ${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg"
}

function _run() {
    echo "Running on device: ${CURRENT_DEVICE}"
    
    # Ensure simulator is running
    _simu
    
    # Build if not already built
    if [[ ! -f "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" ]]; then
        _build
    fi
    
    echo "Running application on simulator..."
    monkeydo ${CURRENT_OPTS} \
        "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" \
        "${CURRENT_DEVICE}"

    echo "Application/Simulator exited."
}

function _debug() {
    echo "Debugging on device: ${CURRENT_DEVICE}"
    _simu
    
    if [[ ! -f "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" ]]; then
        _build
    fi
    
    mdd ${CURRENT_OPTS} \
        --device "${CURRENT_DEVICE}" \
        --executable "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg" \
        --debug-xml "${RDIR}/bin/ActiveLookDataField-${CURRENT_DEVICE}.prg.debug.xml"
}

function _device() {
    CURRENT_DEVICE="${1}"
    if ! printf "%s" "${DEVICES}" | grep -Fxq "${CURRENT_DEVICE}"; then
        echo "Error: Invalid device '${CURRENT_DEVICE}'"
        _help
        exit 1
    fi
}

# Show help if no arguments provided
if [[ $# -eq 0 ]]; then
    _help
    exit 0
fi

# Parse arguments and run commands
while [[ $# -gt 0 ]]; do
    case "${1}" in
        help)
            _help
            CURRENT_OPTS=
            shift
            ;;
        clean)
            _clean
            CURRENT_OPTS=
            shift
            ;;
        doc)
            _doc
            CURRENT_OPTS=
            shift
            ;;
        pack)
            _pack
            CURRENT_OPTS=
            shift
            ;;
        build)
            _build
            CURRENT_OPTS=
            shift
            ;;
        run)
            _run
            CURRENT_OPTS=
            shift
            ;;
        debug)
            _debug
            CURRENT_OPTS=
            shift
            ;;
        simu)
            _simu
            CURRENT_OPTS=
            shift
            ;;
        --device)
            shift
            _device "${1}"
            shift
            ;;
        --random-device)
            _device "${CURRENT_DEVICE}"
            shift
            ;;
        --)
            CURRENT_OPTS=
            shift
            ;;
        *)
            CURRENT_OPTS="${CURRENT_OPTS} ${1}"
            shift
            ;;
    esac
done
