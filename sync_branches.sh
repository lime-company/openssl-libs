# First, add upstream branch:
# $ git remote add upstream https://github.com/hvge/cc7.git
# See following articles for detail:
# - https://help.github.com/articles/configuring-a-remote-for-a-fork/
# - https://help.github.com/articles/syncing-a-fork/"

git ls-remote --exit-code upstream &> /dev/null
if test $? != 0; then
    git remote add upstream https://github.com/hvge/openssl-libs.git
fi

git fetch upstream
git checkout master
git merge upstream/master
