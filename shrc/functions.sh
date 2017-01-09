#!/usr/bin/env bash

tmux_attach () {
  directory_name=$(basename $PWD)
  session_name=${directory_name//\./_}
  if tmux has-session -t $session_name
  then
    tmux attach -t $session_name 2>/dev/null
  else
    tmux new-session -s $session_name -n Editor
  fi
}

# Override default rvm_prompt_info
function rvm_prompt_info() {
  ruby_version=$(~/.rvm/bin/rvm-prompt i v p 2> /dev/null)
  if [[ -n $ruby_version ]]; then
    echo "($ruby_version)"
  else
    echo "(system)"
  fi
}

# mkdir, cd into it
mkcd () {
  mkdir -p "$*"
  cd "$*"
}

# Trash files
function trash () {
  local dir
  for dir in "$@"; do
    # ignore any arguments
    if [[ "$dir" = -* ]]; then :
    else
      local dst=${dir##*/}
      # append the time if necessary
      while [ -e ~/.Trash/"$dst" ]; do
        dst="$dst "$(date +%H-%M-%S)
      done
      mv "$dir" ~/.Trash/"$dst"
    fi
  done
}

# build html from markdown, optimized for legibility on mobile devices
function mdbuild () {
  read -d '' head <<"EOF"
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv=Content-type content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width">
  <title></title>
</head>
<body>
EOF
  local foot="</body>\n</html>\n"
  for input in "$@"; do
    out=${input%.*}.html
    echo $head > $out
    markdown $input | smartypants >> $out
    echo $foot >> $out
  done
}

# run a command multiple times
function dotimes () {
  if [[ $# -lt 2 ]]; then
    echo "usage: dotimes number-of-times command-to-run"
    return 1
  fi
  local max=$1
  local i=0
  local fails=0
  shift
  while [ $i -lt $max ]; do
    i=`expr $i + 1`
    "$@"
    echo -n "\n#### "
    if [[ $? -gt 0 ]]; then
      echo -n "FAILED"
      fails=`expr $fails + 1`
    else
      echo -n "PASSED"
    fi
    echo -n " ($i/$max, $fails fails)"
    echo -n " ####\n\n"
  done
  echo "\n\n#### $fails out of $max runs failed. ####\n"
}

# See http://brettterpstra.com/2013/07/24/bash-image-tools-for-web-designers/
# Quickly get image dimensions from the command line
function imgsize() {
  local width height
  if [[ -f $1 ]]; then
    height=$(sips -g pixelHeight "$1"|tail -n 1|awk '{print $2}')
    width=$(sips -g pixelWidth "$1"|tail -n 1|awk '{print $2}')
    echo "${width} x ${height}"
  else
    echo "File not found"
  fi
}
#
# encode a given image file as base64 and output css background property to clipboard
function 64enc() {
  openssl base64 -in $1 | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "background:url(data:image/"ext";base64,"str1");" }'|pbcopy
  echo "$1 encoded to clipboard"
}

function 64font() {
  openssl base64 -in $1 | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "src:url(\"data:font/"ext";base64,"str1"\")  format(\"woff\");" }'|pbcopy
  echo "$1 encoded as font and copied to clipboard"
}

function show_colors() {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}

man() {
	env \
		LESS_TERMCAP_md=$'\e[1;36m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[1;40;92m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[1;32m' \
			man "$@"
}

heroku_apps() {
  heroku apps --all | awk '{print $1}' | fzf
}

ppid () { ps -p "${1:-$$}" -o ppid=; }
