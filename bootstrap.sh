#!/bin/bash

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
    $DOWNLOADER http://www.rock-robotics.org/autoproj_bootstrap
fi

if which ruby1.9.3 > /dev/null; then
    RUBY="ruby1.9.3"
elif which ruby1.9.2 > /dev/null; then
    RUBY="ruby1.9.2"
elif which ruby1.9.1 > /dev/null; then
    RUBY="ruby1.9.1"
elif which ruby1.9 > /dev/null; then
    RUBY="ruby1.9"
else 
    echo "Please instll ruby 1.9 (if you have it installed, please check the boostrap file for your version"
    exit -1
fi

echo "Found Ruby executable: $RUBY"

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
    $RUBY autoproj_bootstrap $@ git https://github.com/exoter-rover/buildconf.git push_to=git@gitorious.org:$CONF_REPO branch=master
else
    $RUBY autoproj_bootstrap $@ git git@github.com:exoter-rover/buildconf.git push_to=git@github.com:exoter-rover/buildconf.git branch=master
fi

. $PWD/env.sh
autoproj update

echo "\nProject should now be checked out. To compile it type 'amake'."
