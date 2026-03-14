#!/bin/bash

# Set the current directory to the location of this script
pushd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" > /dev/null

# Quit on errors and unset vars
set -o errexit
set -o nounset

# Copy love-api to child directories
cp -rf love-api love-conf
cp -rf love-api lua

# Update after/queries
rm -f ../../after/queries/lua/highlights.scm

# Update test/
rm -f ../../test/example/api_full_list.lua
rm -f ../../test/example/conf.lua

# Create after/queries
$lua lua/treesitter.lua > ../../after/queries/lua/highlights.scm

# Create test/
$lua lua/generate_api_list.lua > ../../test/example/api_full_list.lua
$lua lua/generate_conf.lua > ../../test/example/conf.lua

# Cleanup
rm -rf love-api
rm -rf love-conf
rm -rf lua/love-api

popd > /dev/null
