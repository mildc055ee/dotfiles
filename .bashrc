ICON_CH_CLR='\e[44m' #blue
ICON_BG_CLR='\e[36m' #light blue

BLUE_BG='\e[44m'
GREEN_BG='\e[42m'

BLUE_CH='\e[34m'
BLACK_CH='\e[30m'
GREEN_CH='\e[32m'

STATUS_OK_CLR='\e[0;32m'
STATUS_WARN_CLR='\e[1;33m'
STATUS_NG_CLR='\e[0;31m'
STATUS_BUG_CLR='\e[1;36m'

RESET='\e[0m'

STATUS_OK="${STATUS_OK_CLR}(≧∇≦)b OK${RESET}"
STATUS_WARN="${STATUS_WARN_CLR}（;´▽｀A${RESET}"
STATUS_NG="${STATUS_NG_CLR}く(\"\"0\"\")＞なんてこった!!${RESET}"
STATUS_BUG="${STATUS_BUG_CLR}m(_ _)m promptのバグです${RESET}"

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
    export PS1="$(cmd_state_str $cmd_state)$(icon) $(separate ${GREEN_BG} ${BLUE_CH})$(display ${GREEN_BG} ${BLACK_CH})\W $(separate ${RESET} ${GREEN_CH})[${BRANCH_CLR}$(git_branch_name)${RESET}$(git_status_str)]\n\D{%H:%M} $ "
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

git_status_str () {
  local statuses=$(git status -s 2> /dev/null | sed 's/^ *//' | cut -d ' ' -f 1 | sort | uniq)
  if [ -z "$statuses" ]; then echo $STATUS_OK; return; fi
  if [ -z "${statuses/*U*/}" ]; then echo $STATUS_NG; return; fi
  if [ -z "${statuses/*[RMAD?]*/}" ]; then echo $STATUS_WARN; return; fi
  echo $STATUS_BUG
}

git_branch_name () {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

PROMPT_COMMAND="prompt_process"

