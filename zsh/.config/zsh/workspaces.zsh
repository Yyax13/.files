# $1 = Workspace name
# $2 = Workspace absolute path
__w () {
  cd $2
  printf "\033[3J\033[H\033[2J"
  printf "\nYou are in $1 workspace\n\n"
}

w-scorpion () {
  __w "ScorpionC2" "/home/yyax/Projects/ScorpionC2/"
}

w-tdm () {
  __w "TheDarkMark C2" "/home/yyax/Projects/TheDarkMark/"
}

w-flaqz () {
  __w "Flaqz B2B" "/home/yyax/Projects/flaqz/"
}
