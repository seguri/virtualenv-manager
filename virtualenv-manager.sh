#!/bin/bash

usage() {
    cat << EOF
Usage: ${0##*/} <option>

Options:
    -h    Displays this message
    -i    Install requirements
    -l    List installed packages
EOF
}


# Check arguments length; if non-zero, will continue
(( $# )) || { usage; exit 1; }


create() {
    echo -n "Creating virtualenv... "
    [ -d myenv ] && echo "Found" || { virtualenv myenv > /dev/null 2>&1 && echo "OK"; } || { echo "ERROR"; exit 1; }
}


activate() {
    # source virtualenv and check if virtualenv is providing 'real_prefix'
    echo -n "Activating virtualenv... "
    source myenv/bin/activate && python -c "import sys;sys.exit(78) if not hasattr(sys,'real_prefix') else sys.exit(0)" && echo "OK" || { echo "ERROR"; exit 1; }
}


install() {
    echo -n "Installing requirements... "
    [ -f requirements.txt ] || { echo "ERROR: Missing requirements.txt"; exit 1; }
    pip -q install -r requirements.txt && echo "OK"
}


list() {
    echo "Installed packages:..."
    pip list
}


# ":" set silent error mode, will use OPTARG
while getopts ":hil" opt; do
    case $opt in
        h)
            usage
            exit 1
            ;;
        i)
            create
            activate
            install
            ;;
        l)
            create
            activate
            list
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" >&2
            ;;
    esac
done
