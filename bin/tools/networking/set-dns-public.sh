echo "🔧 Do you want to override system DNS with fast public resolvers? (Cloudflare + Google)"
while true; do
  read -r yn
  case $yn in
    [Yy]* )
      echo "Setting DNS to 1.1.1.1 and 8.8.8.8..."
      networksetup -setdnsservers Wi-Fi 1.1.1.1 8.8.8.8
      break
      ;;
    [Nn]* )
      echo "Skipping DNS change."
      break
      ;;
    * )
      echo "Please answer yes (y) or no (n)."
      ;;
  esac
done
