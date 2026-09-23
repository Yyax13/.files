autoload -U colors && colors
autoload -Uz is-at-least

(( $+functions[work_in_progress] )) || work_in_progress() {}

: ${THEME_PALETTE:=$HOME/.cache/theme/palette.json}
: ${THEME_PALETTE_KEY:=primary}
: ${THEME_PRIMARY_FALLBACK:=#d70000}

zmodload -F zsh/stat b:zstat 2>/dev/null

typeset -g THEME_PALETTE_MTIME=""
typeset -g THEME_PRIMARY=""
typeset -g THEME_RESET="%f%b"
typeset -g base_prompt custom_prompt last_run_time last_vcs_info

typeset -g THEME_TRUECOLOR=0
is-at-least 5.7 && THEME_TRUECOLOR=1

_theme_hex_to_256() {
    local hex=${1#\#}
    local -i r=16#${hex[1,2]} g=16#${hex[3,4]} b=16#${hex[5,6]}
    if (( r == g && g == b )); then
        (( r < 8 ))   && { print -n 16;  return }
        (( r > 248 )) && { print -n 231; return }
        print -n $(( 232 + (r - 8) * 24 / 247 ))
        return
    fi
    print -n $(( 16 + 36 * (r * 5 / 255) + 6 * (g * 5 / 255) + (b * 5 / 255) ))
}

_theme_fg() {
    local c=$1
    if [[ $c == '#'[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F] ]]; then
        (( THEME_TRUECOLOR )) || c=$(_theme_hex_to_256 $c)
    fi
    print -n "%F{$c}"
}

_theme_apply_colors() {
    ZSH_THEME_GIT_PROMPT_PREFIX="${THEME_PRIMARY}["
    ZSH_THEME_GIT_PROMPT_SUFFIX="%b${THEME_PRIMARY}]${THEME_RESET}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%B"
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    base_prompt="${THEME_PRIMARY}[%~% ]%B ᛋᛋ%b${THEME_RESET} "
}

update_theme_colors() {
    local mtime=""

    if [[ -r "$THEME_PALETTE" ]]; then
        local -a st
        if zstat -A st +mtime "$THEME_PALETTE" 2>/dev/null; then
            mtime=$st[1]
        else
            mtime=$(command stat -c %Y "$THEME_PALETTE" 2>/dev/null \
                 || command stat -f %m "$THEME_PALETTE" 2>/dev/null)
        fi
    fi

    [[ "$mtime" == "$THEME_PALETTE_MTIME" ]] && return
    THEME_PALETTE_MTIME=$mtime

    local color=""
    if [[ -n "$mtime" ]]; then
        if (( $+commands[jq] )); then
            color=$(jq -r --arg k "$THEME_PALETTE_KEY" '.[$k] // empty' \
                    "$THEME_PALETTE" 2>/dev/null)
        else
            color=$(sed -n \
                "s/.*\"$THEME_PALETTE_KEY\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" \
                "$THEME_PALETTE" 2>/dev/null | head -1)
        fi
    fi

    THEME_PRIMARY=$(_theme_fg ${color:-$THEME_PRIMARY_FALLBACK})
    _theme_apply_colors
}

update_theme_colors

git_custom_status() {
  local branch=$(git_current_branch)
  [[ -n "$branch" ]] || return 0
  branch="${branch//\%/%%}"
  print "${THEME_PRIMARY}$(work_in_progress)${THEME_RESET}\
${ZSH_THEME_GIT_PROMPT_PREFIX}$(parse_git_dirty)${branch}\
${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

function hg_prompt_info() {
    unset output info parts branch_parts branch

    local output=""
    if ! output="$(hg status 2> /dev/null)"; then
        return
    fi

    local info=$(hg log -l1 --template '{author}:{node|short}:{remotenames}:{phabdiff}')
    local parts=(${(@s/:/)info})
    local branch_parts=(${(@s,/,)parts[3]})
    local branch=${branch_parts[-1]}
    [ ! -z "${parts[3]}" ] && [[ "${parts[1]}" =~ "$USER@" ]] && branch=${parts[3]}
    [ -z "${parts[3]}" ] && branch=${parts[2]}

    local emphasis=""
    [[ ! -z "$output" ]] && emphasis="%B"

    print "${THEME_PRIMARY}[${emphasis}${branch}%b${THEME_PRIMARY}]${THEME_RESET}"
}

export VCS_PROMPT=git_custom_status

function pipestatus_parse {
  PIPESTATUS="$pipestatus"
  ERROR=0
  for i in "${(z)PIPESTATUS}"; do
      if [[ "$i" -ne 0 ]]; then
          ERROR=1
      fi
  done

  if [[ "$ERROR" -ne 0 ]]; then
      print "${THEME_PRIMARY}[%B$PIPESTATUS%b${THEME_PRIMARY}]${THEME_RESET}"
  fi
}

function preexec() {
    last_run_time=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
}

function duration() {
    local duration
    local now=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
    local last=$1
    local last_split=("${(@s/./)last}")
    local now_split=("${(@s/./)now}")
    local T=$((now_split[1] - last_split[1]))
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    local s=$(((now_split[2] - last_split[2]) / 1000000000.))
    local m=$(((now_split[2] - last_split[2]) / 1000000.))

    (( $D > 0 )) && duration+="${D}d"
    (( $H > 0 )) && duration+="${H}h"
    (( $M > 0 )) && duration+="${M}m"

    if [[ $S -le 0 ]]; then
        printf "%ims" "$m"
    else
        if ! [[ -z $duration ]] && printf "%s" "$duration"
        local sec_milli=$((S + s))
        printf "%.3fs" "$sec_milli"
    fi
}

function precmd() {
    update_theme_colors

    RETVAL=$(pipestatus_parse)
    local info=""

    if [ ! -z "$last_run_time" ]; then
        local elapsed=$(duration $last_run_time)
        info=$(printf "%s%s%s%s" "${THEME_PRIMARY}[" "$elapsed" "${THEME_PRIMARY}]${THEME_RESET}" "$RETVAL")
        unset last_run_time
    fi

    if [ -z "$info" -a ! -z "$last_vcs_info" ]; then
        custom_prompt="$last_vcs_info$base_prompt"
        return;
    fi

    if (( ${+VCS_PROMPT} )); then
        last_vcs_info=$($VCS_PROMPT)
        if [ ! -z "$last_vcs_info" ]; then
            [ -z "$info" ] && info=$last_vcs_info || info="$info$last_vcs_info"
        fi
    fi

    [ -z "$info" ] && custom_prompt="$base_prompt" || custom_prompt="$info$base_prompt"
}

setopt PROMPT_SUBST
PROMPT='$custom_prompt'
