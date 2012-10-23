# Set default flags for grep.
#    -I : ignore binary files
export GREP_OPTIONS="-I"

# BSD grep does not support this option.
if [ `uname` != "Darwin" ]; then
    #    --exclude-dir='\.*' : do not recurse into hidden directories
    export GREP_OPTIONS="$GREP_OPTIONS --exclude-dir='\\.*'"
fi
