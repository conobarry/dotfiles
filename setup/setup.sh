#!/usr/bin/env sh

# $1 is the file to add to add to repo
# $2 is the path to put it in

#path="$(dirname $1)"
#file="$(basename $1)"

dotfiles="${HOME}/.dotfiles"

# If filename starts with a period
#if [[ "$file" =~ ^\. ]]; then
    # Remove that period
#    file=${file:1}
#fi

repofile="${dotfiles}/${2}"

echo "mv ${1} ${repofile}"
echo "ln -s ${repofile} ${1}"

# Replace ${HOME} with ~ to make files.txt universal
nicefile=${1/${HOME}/'~'}
echo "echo ${2}: $nicefile >> ${dotfiles}/setup/files.txt"

mv $1 $repofile
ln -s $repofile $1
echo ${2}: $nicefile >> ${dotfiles}/setup/files.txt

