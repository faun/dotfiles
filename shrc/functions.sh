function tmux_attach () {
  `which tmux` attach -t `basename $PWD` 2>/dev/null || `which tmux` new-session -s `basename $PWD`
}

# Subversion
function svgetinfo (){
  sv info $@
  sv log $@
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

# =============================
# = Directory save and recall =
# =============================

# I got the following from, and mod'd it: http://www.macosxhints.com/article.php?story=20020716005123797
#    The following aliases (save & show) are for saving frequently used directories
#    You can save a directory using an abbreviation of your choosing. Eg. save ms
#    You can subsequently move to one of the saved directories by using cd with
#    the abbreviation you chose. Eg. cd ms  (Note that no '$' is necessary.)
#    
#    Make sure to also set the appropriate shell option:
#    zsh:
#      setopt CDABLE_VARS
#    bash:
#      shopt -s cdable_vars

# if ~/.dirs file doesn't exist, create it
if [ ! -f ~/.dirs ]; then
  touch ~/.dirs
fi
# Initialization for the 'save' facility: source the .dirs file
source ~/.dirs

alias show='cat ~/.dirs'
alias showdirs="cat ~/.dirs | ruby -e \"puts STDIN.read.split(10.chr).sort.map{|x| x.gsub(/^(.+)=.+$/, '\\1')}.join(', ')\""

function save (){
  local usage
  usage="Usage: save shortcut_name"
  if [ $# -lt 1 ]; then
    echo "$usage"
    return 1
  fi
  if [ $# -gt 1 ]; then
    echo "Too many arguments!"
    echo "$usage"
    return 1
  fi
  if [ -z $(echo $@ | grep --color=never "^[a-zA-Z]\w*$") ]; then
    echo "Bad argument! $@ is not a valid alias!"
    return 1
  fi
  if [ $(cat ~/.dirs | grep --color=never "^$@=" | wc -l) -gt 0 ]; then
    echo -n "That alias is already set to: "
    echo $(cat ~/.dirs | awk "/^$@=/" | sed "s/^$@=//" | tail -1)
    echo -n "Do you want to overwrite it? (y/n) "
    read answer
    if [ ! "$answer" = "y" -a ! "$answer" = "yes" ]; then
      return 0
    else
      # backup just in case
      cp ~/.dirs ~/.dirs.bak
      # delete existing version(s) of this alias
      cat ~/.dirs | sed "/^$@=.*/d" > ~/.dirs.tmp
      mv ~/.dirs.tmp ~/.dirs
    fi
  fi
  # add a newline to the end of the file if necessary
  if [ $(cat ~/.dirs | sed -n '/.*/p' | wc -l) -gt $(cat ~/.dirs | wc -l) ]; then
    echo >> ~/.dirs
  fi
  echo "$@"=\"`pwd`\" >> ~/.dirs
  source ~/.dirs
  echo "Directory shortcuts:" `showdirs`
}

#### Functions to inspect ruby gems ###########################
## removed old `gemdir` function in favor of a ruby script, see bin/gemdir ##
function cdgem {
  local GEMDIR
  GEMDIR=$(gemdir $1)
  if [ "$GEMDIR" ] && [ -d "$GEMDIR" ]; then
    cd $GEMDIR
  else
    echo "No gem found for $1"
    return 1
  fi
}
function mategem {
  (cdgem $1 && mate .)
}

######## misc ##########

# update dotfiles
function dotfiles_update {
  local SAVED_PWD
  SAVED_PWD="$PWD"
  cd $HOME/src/dotfiles
  git pull --ff-only
  git submodule update --init
  rake install
  cd "$SAVED_PWD"
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

function copypath () {
  echo -n $PWD | pbcopy
}

# project rvmrc files
function rvmrc () {
  if [ $# -lt 1 ]; then
    echo "Trusting existing .rvmrc file"
    rvm rvmrc trust && rvm rvmrc load
  else
    echo "Creating new .rvmrc file"
    cmd="rvm --rvmrc --create use $1"
    echo "running: $cmd"
    eval $cmd
  fi
}

function newest () {
  if [ $# -lt 1 ]; then
    ls -1t | head -n 5 | nl
    echo 'Type `newest #` to open that file.'
  else
    open "$(ls -1t | head -n $1 | tail -n 1)"
  fi
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

# convert tabs to spaces
function tabs2spaces () {
  if [ $# -lt 1 ]; then
    echo "No files provided!"
    return 1
  fi
  for file in "$@"; do
    echo "converting $file"
    cp $file $file.tmp && expand -t 2 $file > $file.tmp && mv $file.tmp $file
  done
}

function sgi {
sudo gem install $1
}

function glg { 
gem list | grep $1
}

function rrg { 
rake routes | grep $1
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
    $@
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

 # see http://brettterpstra.com/2013/07/24/bash-image-tools-for-web-designers/
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
