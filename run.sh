SCRIPT_DIR=$(dirname "$0")

vsim -gmem_content_path=$1 $SCRIPT_DIR/rtl/work.top_tb -c -do "run" -do "quit"
