GOPATH="${HOME:?}/go"
export GOPATH

GOBIN="${GOPATH:?}/bin"
export GOBIN

PATH="${PATH}:${GOBIN}"
export PATH
