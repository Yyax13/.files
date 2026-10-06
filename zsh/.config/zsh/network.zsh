dmip() {
    ip -j addr | jq -r '
        .[] |

        # Interface
        "\u001b[1;36m\(.ifname)\u001b[0m - " +
        (if .operstate == "UP"
            then "\u001b[1;32mUP\u001b[0m"
            else "\u001b[1;31mDOWN\u001b[0m"
        end) +
        ":",

        # MAC / link
        "    \u001b[1;37mlink/\(.link_type)\u001b[0m " +
        "\u001b[1;35m\(.address)\u001b[0m" +
        (if .broadcast
            then " \u001b[1;37mbrd\u001b[0m \u001b[1;35m\(.broadcast)\u001b[0m"
            else ""
        end),

        # IPs
        (.addr_info[] |
            "    " +

            # inet / inet6
            (if .family == "inet"
                then "\u001b[1;33minet\u001b[0m "
                else "\u001b[1;34minet6\u001b[0m "
            end) +

            # endereço
            (if .family == "inet"
                then "\u001b[1;33m\(.local)\u001b[0m"
                else "\u001b[1;34m\(.local)\u001b[0m"
            end) +

            # prefix length
            "\u001b[1;37m/\(.prefixlen)\u001b[0m" +

            # broadcast
            (if .broadcast
                then
                    " \u001b[1;37mbrd\u001b[0m " +
                    "\u001b[1;33m\(.broadcast)\u001b[0m"
                else ""
            end) +

            # scope
            " \u001b[1;37mscope\u001b[0m " +
            "\u001b[1;32m\(.scope // "")\u001b[0m"
        ),

        ""
    '
}

sfuf () {
  nmap -p- -T4 --min-rate 5000 --max-retries 1 -n --open $@
}

# TX/RX per-interface since boot, sorted by traffic, with a TOTAL row
net-get-use () {
    local bold_white=$'\e[1;37m' cyan=$'\e[1;36m' yellow=$'\e[1;33m' \
          magenta=$'\e[1;35m' dim=$'\e[2m' red=$'\e[1;31m' reset=$'\e[0m'

    local data
    data=$(ip -j -s link 2>/dev/null) || {
        printf '%snet-get-use: cannot read link statistics%s\n' "$red" "$reset" >&2
        return 1
    }

    # Gather "ifname<TAB>rx<TAB>tx" rows (bytes since boot), big users first
    local -a rows=()
    local line name w=9
    while IFS= read -r line; do
        rows+=("$line")
        name=${line%%$'\t'*}
        (( ${#name} > w )) && w=${#name}
    done < <(printf '%s' "$data" | jq -r '
        def rx: .stats64.rx.bytes // .stats.rx.bytes // .stats64.rx_bytes // .stats.rx_bytes // 0;
        def tx: .stats64.tx.bytes // .stats.tx.bytes // .stats64.tx_bytes // .stats.tx_bytes // 0;
        [ .[] | { name: .ifname, rx: rx, tx: tx } ]
        | sort_by(-(.rx + .tx))
        | .[] | [.name, (.rx | tostring), (.tx | tostring)] | @tsv
    ')
    (( w > 24 )) && w=24

    # Header
    printf '%s%-*s %14s %14s%s\n' "$bold_white" "$w" "Interface" "RX" "TX" "$reset"

    # Rows
    local rx tx hrx htx rest
    for line in "${rows[@]}"; do
        name=${line%%$'\t'*}
        rest=${line#*$'\t'}
        rx=${rest%%$'\t'*}
        tx=${rest#*$'\t'}
        hrx=$(LC_ALL=C numfmt --to=iec-i --suffix=B "$rx" 2>/dev/null) || hrx="${rx}B"
        htx=$(LC_ALL=C numfmt --to=iec-i --suffix=B "$tx" 2>/dev/null) || htx="${tx}B"
        printf '%s%-*s%s %14s %14s%s\n' "$cyan" "$w" "$name" "$yellow" "$hrx" "$htx" "$reset"
    done

    # Separator + total
    local sep total_rx total_tx htrx httx
    sep=$(printf '%*s' $(( w + 30 )) '' | tr ' ' '-')
    printf '%s%s%s\n' "$dim" "$sep" "$reset"
    total_rx=$(printf '%s' "$data" | jq '
        [ .[] | (.stats64.rx.bytes // .stats.rx.bytes // .stats64.rx_bytes // .stats.rx_bytes // 0) ] | add // 0')
    total_tx=$(printf '%s' "$data" | jq '
        [ .[] | (.stats64.tx.bytes // .stats.tx.bytes // .stats64.tx_bytes // .stats.tx_bytes // 0) ] | add // 0')
    htrx=$(LC_ALL=C numfmt --to=iec-i --suffix=B "$total_rx" 2>/dev/null) || htrx="${total_rx}B"
    httx=$(LC_ALL=C numfmt --to=iec-i --suffix=B "$total_tx" 2>/dev/null) || httx="${total_tx}B"
    printf '%s%-*s%s %14s %14s%s\n' "$magenta" "$w" "TOTAL" "$yellow" "$htrx" "$httx" "$reset"
}
