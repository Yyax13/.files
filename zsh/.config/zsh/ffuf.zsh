vhost-get-baseline () {
  if [ $# -ne 2 ]; then
    echo "Usage: vhost-get-baseline <http|https> <host>"
    return 1
  fi

  for i in {1..25}; do                                                                    
    curl -s -k -o /dev/null -w '%{http_code} %{size_download}\n' \
      -H "Host: random-$i.$2" \
      "$1://$2"
  done
}

vhost-enum () {
  if [ $# -ne 3 ]; then
    echo "Usage: vhost-enum <http|https> <host> <baseline>"
    return 1
  fi

  ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt \
    -u "$1://$2" \
    -H "Host: FUZZ.$2" -fs $3 -c
}
