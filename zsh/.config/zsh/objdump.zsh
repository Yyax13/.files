o () {
  objdump -M intel -C "$@" | bat -l asm --theme=ansi

}

od () {
  o -d "$@"

}

oda () {
    start=$(printf "0x%x" $(($2 - 0x200)))
    stop=$(printf "0x%x" $(($2 + 0x200)))

    objdump -C -d -M intel \
        --start-address=$start \
        --stop-address=$stop \
        "$1" | bat -l asm --theme=ansi

}

odax () {
    start=$(printf "0x%x" $2)
    stop=$(printf "0x%x" $(($2 + 0x400)))

    objdump -C -d -M intel \
        --start-address=$start \
        --stop-address=$stop \
        "$1" | bat -l asm --theme=ansi

}

oh () {
  printf "O-based help menu\n\n"
  printf "o\t\t Raw objdump, should use -d\n"
  printf "od\t\t o with -d\n"
  printf "oda\t\t Show code between $1 - 200 and $1 + 200\n"
  printf "odax\t\t Show code after (including) $1\n\n"
}
