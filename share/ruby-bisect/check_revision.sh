#!/usr/bin/env bash

source "${0%/*}/util.sh"

#
# Finds svn_id of last commit
#
function last_revision() {
  git show -s --pretty=format:'%b' | grep -E -o "trunk@[0-9]+" | cut -d@ -f2
}

# Construct names
revision=$(last_revision)
ruby_version_name=ruby-$revision
ruby_install_dir=$HOME/.rubies/$ruby_version_name
project_dir=$1

shift $(($(n_args "$@") + 1))

# Cleanup source dir in case it's in a bad state
run git clean -fd

# Generate configure script if needed
if [[ ! -s configure || configure.in -nt configure ]]
then
  run autoconf
fi

# Configure Ruby
run ./configure --disable-install-doc --prefix="$ruby_install_dir"

# Compile and install Ruby
run make && run make install

# Back to projects directory
cd "$project_dir" || exit 1

# Run passed command against the new ruby
run chruby-exec "$ruby_version_name" -- "$@"
