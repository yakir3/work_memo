function log2bashaudit {
    export HISTTIMEFORMAT="[%F %T] [`who am i 2>/dev/null |awk -F'[() ]+' '{print $1, $(NF-1)}'`] "
    export PROMPT_COMMAND='\
        if [ -z "$OLD_PWD" ]; then
            export OLD_PWD=$(pwd);
        fi;
        if [ ! -z "$LAST_CMD" ] && [ "$(history 1)" != "$LAST_CMD" ]; then
            logger `whoami`_shell_cmd "[$OLD_PWD]$(history 1)";
        fi;
        export LAST_CMD="$(history 1)";
        export OLD_PWD=$(pwd);'
}
trap log2bashaudit DEBUG

export PS1="\[\e[37;1m\][\[\e[35;1m\]\u\[\e[32;1m\]@\[\e[34;1m\]\h \[\e[31;1m\]\w]# \[\e[0m\]"
