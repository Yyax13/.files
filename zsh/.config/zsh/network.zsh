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
