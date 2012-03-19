# ~/.gdbinit
# vim:ft=gdb:

# Use the vtable to print the real object instead of the pointed type.
set print object on

# Format structs/objects for easy reading (uses more lines).
set print pretty on

# Stop printing strings after the first null character.
set print null-stop on
