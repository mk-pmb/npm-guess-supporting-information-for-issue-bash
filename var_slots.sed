#!/bin/sed -nurf
# -*- coding: UTF-8, tab-width: 2 -*-

: skip
  /^#+ supporting information:/b suppi
  n
b skip

: suppi
  n
  /^<!/b skip
  /^#/b skip
  s~\s+$~~
  /^$/b suppi
  s~^[ -]+`([a-z -]+)` prints:$~& %%\v\1%%~i
  s~^[ -]+windows.* or linux\?:$~& %%opsys%%~i
  s~^[ -]+(geo)graphic (location).*:$~& %%\L\1\2\E%%~i

  s~^([ -]+\[)[_ ](\] I use a (proxy) (($\
    |when|to|connect|the|download|ing|$\
    ) ?)+([a-z ]+)\.?)$~\1\L%%\3_\v\6%%\E\2~i

  s~^([ -]+\[)[_ ](\] I access the ([a-z ]+) via a ([a-z ]+|$\
    )\.?)$~\1\L%%\v\4_\3%%\E\2~i

  s~^([ -]+\[)[_ ](\] .* have (limited) .* (internet) access\.?|$\
    )$~\1\L%%\v\3_\4_noproxy%%\E\2~i

  s~^([ -]+\[)[_ ](\] I (develop|deploy) (($\
    |/|deploy|$\
    ) ?)*(using|to) ([a-z ]+))~\1\L%%\v\3_\7%%\E\2~i



  /%%/!s~$~\a~
  s~^([ -]+(network issues|container):)\a~\1~i
  s~^([ -]+)(\[[ _]\].*)\a$~\1\a \2~

  s~\a~%%unsupported_question%%~

  : v_usc
    s~\v([ _-]*(a|on|or)\b)+~\v~g
    s~\v[ _-]+([a-z]+)~_\1\v~g
    s~\v[ _-]+(%)~\1~g
    s~\v([a-z]+)~\1\v~g
  t v_usc
  s~\v~~g
  p
b suppi
