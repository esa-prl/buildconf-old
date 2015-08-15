#!/bin/bash

CONF_REPO=envire/buildconf.git
RUBY=ruby
AUTOPROJ_BOOTSTRAP_URL=http://rock-robotics.org/stable/autoproj_bootstrap

set -e

if ! test -f $PWD/autoproj_bootstrap; then
    if which wget > /dev/null; then
        DOWNLOADER=wget
    elif which curl > /dev/null; then
        DOWNLOADER=curl
    else
        echo "I can find neither curl nor wget, either install one of these or"
        echo "download the following script yourself, and re-run this script"
        exit 1
    fi
    $DOWNLOADER $AUTOPROJ_BOOTSTRAP_URL
fi


echo "Do you want to use the git protocol to access the build configuration ?"
echo "If the protocol is blocked by your network answer with no. The default is yes."

# Check and interprete answer of "[y|n]"
ANSWER="wrong"
until test "$ANSWER" = "y" || test "$ANSWER" = "n" || test "$ANSWER" = ""
do
    echo "Use git protocol? [y|n] (default: y)"
    read ANSWER
    ANSWER=`echo $ANSWER | tr "[:upper:]" "[:lower:]"`
done

if [ "$ANSWER" = "n" ]; then
    $RUBY autoproj_bootstrap $@ git https://github.com/exoter-rover/buildconf.git push_to=git@github.com:exoter-rover/buildconf.git branch=master
else
    $RUBY autoproj_bootstrap $@ git git@github.com:exoter-rover/buildconf.git push_to=git@github.com:exoter-rover/buildconf.git branch=master
fi

if test "x$@" != "xlocaldev"; then
    . $PWD/env.sh
    autoproj update
    autoproj fast-build
fi

