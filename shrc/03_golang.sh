GOROOT="${GOROOT:-${HOME:?}/src}"
export GOROOT

GOPATH="${HOME:?}/go"
export GOPATH

GOBIN="${GOPATH:?}/bin"
export GOBIN

PATH="${PATH}:${GOBIN}"
export PATH

GOPROXY="${GOPROXY:-https://proxy.golang.org}"
