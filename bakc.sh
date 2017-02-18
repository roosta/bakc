#!/bin/bash
# Author: Roosta <mail@roosta.sh>
# ----------------------------------------
# backup directory in home(.backup) with directory structure of
# source file. (~/.backup/[PATH]/FILE)
# Append dateformatted date and .bak to file (FILENAME.DATE.bak)
# TODO:
# [ ] verbose
# [ ] add clean
# [x] conf file?
# [ ] add restore
# [ ] move option
# [ ] include home directory in elevated mode
# [x] custom location
# [ ] include a temp option
# [ ] add undo delete
# [ ] add archive function
# [ ] fix success on failed message

# -----------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

wflag=
Rflag=

source "$HOME/.bakcrc"
file_backup_long() {
  if [[ -f $1 || -d $1 ]]; then
    canon=$(readlink -f "${1}")
    # target_path=$(dirname ${canon})
    target_file=$(basename "${1}")
    destination=${bakc__backup_path:?}$(dirname "${canon}")
    if [[ ! -d "$destination" ]]; then
      mkdir -p "$destination"
    fi
    cp -Lrx "${1}" "${destination}/${target_file}~${bakc__file_suffix:?}"
    echo "backed up '${1}' to ${destination}/${target_file}~${bakc__file_suffix:?}"
  else
    echo "failed to backup: ${1}. Not a valid file" >&2
  fi
}

file_backup_short() {
  if [[ -f $1 || -d $1 ]]; then
    cp -Lri "${1}" "$(basename "${1}").bak"
    echo "Created ${1}.bak here ($(pwd))"
  else
    echo "Not a valid file" >&2
    exit 1
  fi
}

file_remove() {
  if [[ -f $1 ]]; then
    rm -Iv --one-file-system "${1}"
  elif [[ -d $1 ]]; then
    rm -Irv --one-file-system "${1}"
  else
    echo "Failed to remove: ${1}. Check permissions" >&2
  fi
}

usage() {
	cat >&2 <<EOL
Usage: bakc [OPTION] SOURCE

options:
  -w         Save source file in working directory with .bak extension
  -R         Remove file after backup
  -h         Display this message
EOL
}

run() {
  if [[ $# -gt 0 ]]; then
    while [[ $# -ne 0 ]]; do
      if [[ ! -z $Rflag && ! -z $wflag ]]; then
        file_backup_short "$1"
        file_remove "$1"
      elif [[ ! -z $Rflag ]]; then
        file_backup_long "$1"
        file_remove "$1"
      elif [[ ! -z $wflag ]]; then
        file_backup_short "$1"
      else
        file_backup_long "$1"
      fi
      shift
    done
    exit 0
  else
    echo "Provide a file to backup" >&2
  fi
}

options=":hwR"
while getopts ${options} opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    w)
      wflag=1
      ;;
    R)
      Rflag=1
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      exit 1
      ;;
    :)
      echo "Option -${OPTARG} requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))
run "$@"

