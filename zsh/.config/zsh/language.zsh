loadgvm() {
    [[ -s "$HOME/.gvm/scripts/gvm" ]] || {
        echo "GVM não encontrado em ~/.gvm"
        return 1
    }

    source "$HOME/.gvm/scripts/gvm"
}
