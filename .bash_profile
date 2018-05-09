if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

eval "$(rbenv init -)"
export PYENV_ROOT=${HOME}/.pyenv
export PYENV_SHELL=bash

if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

eval export PATH="/Users/KenzaburoTakagi/.pyenv/shims:${PATH}"
command pyenv rehash 2>/dev/null

pyenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")";;
  *)
    command pyenv "$command" "$@";;
  esac
}
