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
  ls;
}

alias ls="ls -G"
alias rake="bundle exec rake"
alias rails="bundle exec rails"
alias r="rails"
alias cd="cdls"
alias d="docker-compose run web"
alias dd="docker-compose down"
alias du="docker-compose up"
alias dp="docker-compose ps"
alias ds="docker-compose run --service-ports web"
alias st="git status"
alias co="git checkout"
alias diff="git diff"
alias add="git add"
alias push="git push"
alias pull="git pull"
alias cm="git commit"
alias br="git branch"
alias fe="git fetch"
alias gg="git grep"
alias vi="vim"
alias vii="vim +"

