export LSCOLORS=gxfxcxdxbxegedabagacad
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
source /usr/local/etc/bash_completion.d/git-completion.bash

function length()
{
  echo -n ${#1}
}

function init-prompt-git-branch()
{
  git symbolic-ref HEAD 2>/dev/null >/dev/null &&
  echo "($(git symbolic-ref HEAD 2>/dev/null | sed 's/^refs\/heads\///'))"
}

if which git 2>/dev/null >/dev/null
then
  export PS1_GIT_BRANCH='\[\e[$[COLUMNS]D\]\[\e[1;31m\]\[\e[$[COLUMNS-$(length $(init-prompt-git-branch))]C\]$(init-prompt-git-branch)\[\e[$[COLUMNS]D\]\[\e[0m\]'
else
  export PS1_GIT_BRANCH=
fi
export PS1=" \[\e[33m\w $PS1_GIT_BRANCH\n\[\e[34m\]\@ \[\e[0m\]\$ "
eval "$(direnv hook bash)"
export EDITOR=vim

function cdls() {
# cdがaliasでループするのでをつける
 \cd $1;
  ls -G;
}

# search history
export HISTCONTROL="ignoredups"
peco-history() {
    local NUM=$(history | wc -l)
    local FIRST=$((-1*(NUM-1)))

    if [ $FIRST -eq 0 ] ; then
        history -d $((HISTCMD-1))
        echo "No history" >&2
        return
    fi

    local CMD=$(fc -l $FIRST | sort -k 2 -k 1nr | uniq -f 1 | sort -nr | sed -E 's/^[0-9]+[[:blank:]]+//' | peco | head -n 1)

    if [ -n "$CMD" ] ; then
        history -s $CMD

        if type osascript > /dev/null 2>&1 ; then
            (osascript -e 'tell application "System Events" to keystroke (ASCII character 30)' &)
        fi
    else
        history -d $((HISTCMD-1))
    fi
}

# search current directory
peco-find() {
  local l=$(\find . -maxdepth 8 -a \! -regex '.*/\..*' | peco)
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${l}${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(($READLINE_POINT + ${#l}))
}

function peco-find-all() {
  local l=$(\find . -maxdepth 8 | peco)
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${l}${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(($READLINE_POINT + ${#l}))
}

bind -x '"\C-uc": peco-find'
bind -x '"\C-ua": peco-find-all'
bind -x '"\C-r":peco-history'

alias ls="ls -G"
alias rake="bundle exec rake"
alias rails="bundle exec rails"
alias cd="cdls"
alias st="git status"
alias co="git checkout"
alias diff="git diff"
alias cm="git commit"
alias gg="git grep"
alias vi="vim"
alias g='cd $(ghq root)/$(ghq list | peco)'
