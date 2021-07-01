#!/bin/bash

# vim: set ts=4 sw=4 smartindent autoindent:

base_dir=$(dirname "$0")
data_dir=$base_dir/data

# shellcheck source=./data/crush-utils.sh
. "$data_dir"/crush-utils.sh

verbose=0

function usage() {
    #
    # This function always exits, it never returns
    #
    echo
    echo "Usage: $0 outout-file-name"
    echo "  Gather the state of the pools and crush rules."
    echo 
    exit 1
}

if [[ -z $1 ]]; then
    echo_error "Output file name is mandatory"
    usage
fi

ofile=$1

set -o noclobber 

echo " Ceph pools" 2> /dev/null 1> "$ofile"
if [[ $? -ne 0 ]]; then
    echo_error "Cannot overwrite existing file '$ofile'"
    exit
fi

{
echo " ==========";
ceph osd pool ls detail;

echo ""; 
echo " Crush rules";
echo " ===========";
ceph osd crush rule dump;
} >> "$ofile"

echo "Output was saved to $ofile"

exit

