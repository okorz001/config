# The history file lets command history persist between shells.
HISTFILE="$HOME/.bash_history"

# The number of commands to remember.
HISTSIZE="1024"

# The maximum number of lines in the history file.
HISTFILESIZE="2048"

# Append to the history file instead of overwriting.
shopt -s histappend

# Ignore commands that are immediately repeated or start with a space.
# Note that if a command is repeated out-of-order it will not be ignored.
HISTCONTROL="ignorespace:ignoredups"

# Colon delimited command ignore list using glob syntax.
# Common argument-less commands are not very interesting.
HISTIGNORE="exit:clear:ls:ll:la"

# Save and update history after every command.
PROMPT_COMMAND="history -a; history -r"
