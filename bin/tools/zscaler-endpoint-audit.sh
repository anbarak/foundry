#!/bin/sh

HOSTS="
pypi.org
files.pythonhosted.org
registry.npmjs.org
dl-cdn.alpinelinux.org
repo.mysql.com
deb.debian.org
security.debian.org
archive.ubuntu.com
security.ubuntu.com
rubygems.org
proxy.golang.org
sum.golang.org
crates.io
static.crates.io
registry-1.docker.io
auth.docker.io
ghcr.io
quay.io
public.ecr.aws
gcr.io
registry.k8s.io
mcr.microsoft.com
github.com
api.github.com
raw.githubusercontent.com
objects.githubusercontent.com
bitbucket.org
api.bitbucket.org
"

printf "%-40s %-10s %s\n" "HOST" "RESULT" "ISSUER"
printf "%-40s %-10s %s\n" "----" "------" "------"

for host in $HOSTS; do
  issuer=$(echo | openssl s_client -connect "${host}:443" -servername "$host" 2>/dev/null | openssl x509 -noout -issuer 2>/dev/null | sed 's/issuer=//' | cut -c1-70)

  if echo "$issuer" | grep -qi "zscaler"; then
    result="BLOCKED"
  elif [ -z "$issuer" ]; then
    result="NO-CONN"
  else
    result="OK"
  fi

  printf "%-40s %-10s %s\n" "$host" "$result" "$issuer"
done
