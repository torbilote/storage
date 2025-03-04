# to log commits and branches
git log --oneline --all --graph







# to redo commit, make add. changes
# takes staging area and uses it for commit with new message
# works on local commits only
git commit --amend

# to unstage changes
git restore --staged <filename>

# to unmodify file (revert back to the last commited version)
git restore <filename>




# to display remotes
git remote -v

# to display info about particular remote
git remote show <shortname>

# to add remote
git remote add <shortname> <url>

# to get data from origin, only downloads, not merge
git fetch <shortname>
git fetch origin # example

# to rename remote
git remote rename <shortname_old> <shortname_new>

# to remove remote
git remote remove <shortname>


# to list existing tags
git tag

# to create annotated tag
git tag -a <tag_name> -m <tag_message>
git tag -a <tag_name> <commit checksum>
git tag -a v1.4 -m "my version v1.4"
git tag -a v1.4 9fceb02

# to show tag data
git show <tag_name>
git show v1.4

# to push tag to remote (by default push does not transfer tags)
git push origin <tag_name>

# to delete tag
git tag -d <tag_name>

# to view the version of files a tag is pointing to
git checkout <tag_name>


# to set up your username and email
git config --local user.name <username>
git config --local user.email <username>

# to define alias
git config --local alias.lg 'log --oneline --graph' #ie


# to create branch and switch to it
git switch -c <branch_name>

# to switch to differnet branch
git switch <branch_name>

# to return to recently checked out branch
git switch -

# to delete branch
git branch -d <branch_name>

# to list branches witch bunch of details
git branch -vv

# to delete branch in remote
git push origin --delete <branch_name>

# to set/change upstream remote branch of your local branch
git branch -u <remote_branch>
git branch -u origin/hotfix #ie













