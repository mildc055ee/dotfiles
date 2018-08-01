ICON_CH_CLR='\e[44m' #blue
ICON_BG_CLR='\e[36m' #light blue

BLUE_BG='\e[44m'
GREEN_BG='\e[42m'
RED_BG='\e[41m'
PURPLE_BG='\e[45m'

BLUE_CH='\e[34m'
BLACK_CH='\e[30m'
GREEN_CH='\e[32m'
RED_CH='\e[31m'
PURPLE_CH='\e[35m'

STATUS_OK_CLR='\e[0;32m'
STATUS_WARN_CLR='\e[1;33m'
STATUS_BUG_CLR='\e[1;36m'

RESET='\e[0m'


if [ "$(uname)" = Darwin ]; then
        SYSTEM_ICON=""
elif [ -n "`cat /proc/version | grep Microsoft`" ]; then
        SYSTEM_ICON=""
elif [ "$(uname)" = Linux ]; then
        SYSTEM_ICON=""
fi

icon () {
    echo "${RESET}${ICON_BG_CLR}${ICON_CH_CLR} $SYSTEM_ICON"
}

separate () {
    local bg=$1
    local ch=$2
    echo "${RESET}${bg}${ch} "
}

display () {
    local bg=$1
    local ch=$2
    echo "\e[0m${bg}${ch}"
}

STATUS_NG="$(display ${RED_BG} ${BLACK_CH}) ! $(separate ${BLUE_BG} ${RED_CH})${RESET}"
STATUS_BUG="${STATUS_BUG_CLR}m(_ _)m promptのバグです${RESET}"

prompt_process () {
  local cmd_state=$?
  if [ -z "$(git rev-parse --git-dir 2> /dev/null)" ]; then
      SYSTEM_ICON=""
      export PS1="$(cmd_state_str $cmd_state)$(icon) $(separate ${GREEN_BG} ${BLUE_CH})$(display ${GREEN_BG} ${BLACK_CH})\W $(separate ${RESET} ${GREEN_CH})${RESET}\n\D{%H:%M} $ "
  else
    if [ -z "$OLD_PS1" ]; then
        export OLD_PS1=$PS1
    fi
    SYSTEM_ICON=
    export PS1="$(cmd_state_str $cmd_state)$(icon) $(separate ${GREEN_BG} ${BLUE_CH})$(display ${GREEN_BG} ${BLACK_CH})\W $(separate ${PURPLE_BG} ${GREEN_CH})$(display ${PURPLE_BG} ${BLACK_CH})  $(git_branch_name) $(separate ${RESET} ${PURPLE_CH})$RESET\n\D{%H:%M} $ "
  fi
}

cmd_state_str () {
  local status=$1
  local status_str="$status"
  if [ "$status" = 0 ]; then
    status_str=""
  else
    status_str=$STATUS_NG
  fi
  echo $status_str
}

git_branch_name () {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

PROMPT_COMMAND="prompt_process"

