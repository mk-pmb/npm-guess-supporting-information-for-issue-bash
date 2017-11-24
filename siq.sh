#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function siq () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m "$BASH_SOURCE"/..)"
  # cd "$SELFPATH" || return $?
  local APP_NAME="$(basename "$SELFPATH")"

  local RUNMODE="$1"; shift

  local -A SIQ
  siq_capture_cmd npm -v
  siq_capture_cmd node -v
  siq_capture_cmd npm config get registry
  siq_guess_opsys
  siq_guess_proxies

  local APP_SUBDIR="nodejs/npm/$APP_NAME"
  local REPO_URL='https://github.com/npm/npm'
  local TPL_URL="$REPO_URL/raw/latest/.github/issue_template.md"
  local TPL_CACHE="$HOME/.cache/$APP_SUBDIR"
  mkdir -p "$TPL_CACHE" || return $?
  TPL_CACHE+="/tpl.$(date +%F).md"
  local CFG_FN="$HOME/.config/$APP_SUBDIR.rc"
  source "$CFG_FN"

  if [ ! -s "$TPL_CACHE" ]; then
    wget --no-clobber --output-document="$TPL_CACHE".$$.tmp \
      -- "$TPL_URL" || return $?
    mv --no-clobber --no-target-directory \
      -- "$TPL_CACHE"{.$$.tmp,} || return $?
  fi


  "$FUNCNAME"_"${RUNMODE:-answer}" "$@"
  return $?
}


function siq_demo () {
  local EXO='tmp.howto.txt'
  echo '$ '"$APP_NAME" >"$EXO" || return $?
  siq_answer >>"$EXO" || return $?
  readme-ssi || return $?
  return 0
}


function siq_capture_cmd () {
  local SLOT="$(<<<"${*,,}" tr -s ' _-' _)"
  SIQ["$SLOT"]="$("$@" 2>&1)"
}


function siq_detect_var_slots () {
  sed -nrf "$SELFPATH"/var_slots.sed -- "$TPL_CACHE"
}


function siq_guess_opsys () {
  local OS="$(uname --operating-system)"
  case "${OS,,}" in
    *linux* )
      SIQ[develop_vagrant_windows]=' '
      ;;
    win* )
      SIQ[develop_vagrant_os_x_linux]=' '
      ;;
  esac

  local LSB="$(lsb_release -sdc 2>/dev/null)"
  [ -n "$LSB" ] && OS+=" (${LSB//$'\n'/ })"
  SIQ[opsys]="$OS"
}


function siq_guess_proxies () {
  SIQ[proxy_npm_registry]=' '
  npm config list | grep -qoPe '^\s*[\w\-]*proxy\s*=' -m 1 \
    && SIQ[proxy_npm_registry]='x'
  SIQ[proxy_web]=' '
  env | grep -qPie '^https?_proxy=' -m 1 && SIQ[proxy_web]='x'
}


function siq_var_slots_cfg2sed () {
  local SLOT=
  for SLOT in "${!SIQ[@]}"; do
    [ -n "${SIQ[$SLOT]}" ] && echo "$SLOT ${SIQ[$SLOT]}"
  done | LANG=C sed -re '
    s~[^A-Za-z0-9_ ]~\\&~
    s~^(\S+) ~s!%%\1%%!~
    s~$~!g~
    '
}


function siq_answer () {
  local QSNR="$( siq_detect_var_slots | sed -rf <(siq_var_slots_cfg2sed) )"
  local UNVARS=()
  readarray -t UNVARS < <(<<<"$QSNR" LANG=C grep -oPe '%%\w+%%' | sort -Vu)
  if [ -n "${UNVARS[0]}" ]; then
    echo "E: some vars are missing in config: $CFG_FN" >&2
    echo "# for checkboxes, put ' ' or 'x'."
    printf "SIQ[%s]=''\n" "${UNVARS[@]//%/}"
    return 4
  fi

  echo "$QSNR"
  return 0
}










siq "$@"; exit $?
