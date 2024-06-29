SCRIPT_DIR=$(dirname "$0")

vsim -gmem_content_path=$1 -gsignature_path=$2 $SCRIPT_DIR/rtl/work.top_tb -c -do "run -all" -quiet
