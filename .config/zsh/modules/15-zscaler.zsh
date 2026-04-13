# ~/.config/zsh/modules/15-zscaler.zsh
#
# Zscaler TLS inspection support for CLI tools that don't use the
# macOS system trust store (Node, Python, AWS CLI, git, curl).
#
# The macOS system keychain handles browsers and Safari/Chrome/system
# tools once the Zscaler root is marked trusted via:
#   sudo security add-trusted-cert -d -r trustRoot \
#     -k /Library/Keychains/System.keychain ~/.certs/zscaler-root.pem
#
# This module wires up the env vars that dev-toolchain tools need.
# The file-existence guard makes this safe to ship in dotfiles across
# machines that don't have Zscaler installed.

ZSCALER_CERT="$HOME/.certs/zscaler-root.pem"

if [[ -f "$ZSCALER_CERT" ]]; then
  export NODE_EXTRA_CA_CERTS="$ZSCALER_CERT"
  export REQUESTS_CA_BUNDLE="$ZSCALER_CERT"
  export SSL_CERT_FILE="$ZSCALER_CERT"
  export AWS_CA_BUNDLE="$ZSCALER_CERT"
  export CURL_CA_BUNDLE="$ZSCALER_CERT"
  export GIT_SSL_CAINFO="$ZSCALER_CERT"
fi

unset ZSCALER_CERT
