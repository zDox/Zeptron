SCRIPT_DIR=$(dirname "$0")
cd $SCRIPT_DIR/rtl
vlog -sv *.sv */*.sv
