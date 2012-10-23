# Set the locale to American and Unicode 8.
export LANG="en_US.UTF-8"

# Use simple ASCII sorting. This puts '.' before [0-9] then [A-Z] then [a-z].
# This could screw up things depending on en_US.UTF-8 sort (where A = a).
export LC_COLLATE="C"
