# shellcheck shell=bash
# =============================================================================
# Go Development Aliases
# =============================================================================
alias gobuild='go build'
alias goinstall='go install'
alias gotest='go test'
alias goclean='go clean'
alias godep='go mod tidy'
alias gomod='go mod'
alias gofmt='gofmt -w'
alias golint='golint'
alias govet='go vet'
alias goget='go get'
alias gocover='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
alias goreplace='go mod edit -replace'
alias goclone='go get -d'
alias goenv='go env'
alias gorelease='goreleaser'
alias gomodv='go mod verify'
