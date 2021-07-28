N_PREFIX="${N_PREFIX:-$HOME/n}"
if [[ -d "$N_PREFIX" ]]
then
  export N_PREFIX
  [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi
