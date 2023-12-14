Git Tools
=========

This is a set of useful commands to help with `git`.

####  git-cb `<branch>` `<remotespec>`

Creates a local branch, possibly bound to a remote branch from upside, drawn off
your currently set branch.

The `<branch>` name is of your choice. The `<remotespec>` should be one of:

* `.` - create a local branch with no remote binding
* `=` - use the default "origin" remote
* `=P` - use the remote which's name starts with P
* `R` - use the remote with given (full) name R
* `R/B` - use the remote R and the remote branch name B

Unless you used `.`, the new branch will be automatically set to track a remote
branch. Git doesn't like this exactly, so it will display some warning, which
you should ignore. The branch state will be created, but with no commits. After
you push at least one commit to this, the state will be correct and you can push
commits to the remote branch since then on.


####  git-del `<repo-file>`

This deletes the file from the repository - that is, from the working directory perspective it turns the in-repo
file into a private file. Unlike `git rm`, the file isn't removed from the directory.

This is actually an alias to `git rm --cached`. The usual `git rm X` should be treated as `git del X; rm X`.

####  git-distill-patch `<parent-branch> <patch-overlay-file>`

This is useful when you have some your own changes on the git repository view, which you'd like to preserve, but
you want to share all other your changes with the upstream.

To use it, you should first make those non-shareable changes **only** in the
repository, then create a patch out of the current set of changes and save it
as `<patch-overlay-file>`. Since now your "private changes" are locked in this
file. After you made then changes that you'd like to share, use
`git-distill-patch` to create a patch containing all changes except those in
the patch overlay file. The results will be still for you to check: `PATCH`
file will contain the complete patch, while `PATCH.distilled` will contain the
patch purged of your private changes (as defined in `<patch-overlay-file>`).
This script is only a forwarder, the whole job will be done by
`patch-distill.tcl` script.

####  git-getpin `?submodule-repo?`

This returns the SHA1 code of the commit by which a submodule is pinned into the parent repository. Without arguments
it returns the pinned commit of the submodule that your current working directory points to. Optional argument is the
path to the submodule repository. This is useful to check if the current __checkedout__ version of the submodule is
the same as the __pinned__ version in the parent repository. If they differ, it usually means that you should either
do `git add` for this submodule repository in the parent repository, or change the HEAD of the submodule to the one
that is returned by `git getpin`.

####  git-graphviz

This creates a version diagram using __grahpviz's dot__ tool and runs a picture viewer to see it (default: eog). Options
with their defaults are shown when run.

####  git-man

Alias to `git help`.

####  git-most

This displays the "most useful set of information" for the current repository:
the repo's origin, the SHA1 code of the current branch and version, and the
currently modified files, both in the stage and in the view. By default it
doesn't display view private files, override it by -u option.

By default it displays the header with the overall information and then possibly
the modified files. The "only" option (-o) allows to display only files with appropriate
status according to the schema: -o[s|v]m|a|d|o|u (s or v is optional after -o, plus one
of m/a/d/o/u must be present):

* m: modified files
* a: added files
* d: deleted files
* o, u: other/untracked files

Optional `s` or `v` limit the selection to files that have given status in the _stage_
or _view_ respectively. Without this option it shows from both. Note of course that
for state options `o`/`u` the `s` or `v` selection is ignored.

Files displayed with -o option have no header and no extra information, this option is
predicted to be used with additional pipe processing.

####  git-new-workdir `<base-dir>` `<new-dir>` `?branch?`

This is a copy of a git-new-workdir script taken from
[Git contrib](https://github.com/git/git/tree/master/contrib/workdir). Placed here
only for convenience.

This script allows you to create a secondary view-stage pair connected to the same
repository replica. It allows you to work on independent versions at a time using
separate working directories, but using one replica storage. This can save your
diskspace and time by not uselessly multiplying repository replicas on one disk,
only to have multiple working directories.

####  git-prefix

Returns the current working directory starting from the current git view working directory.

####  git-rolling-resolve

This tool is useful only for teams that use rebase-mode workflow. This does rebase and merge
in loop, until the rebase states that there are no more conflicts.

####  git-sp

This is a helper script for `git subtree`. It supplies automatically the --prefix option that
`git subtree` normally requires. Useful only if you use `git subtree` tool. The prefix is taken
from the current directory. Note that `git subtree` requires that the current directory is the
git toplevel directory.

####  git-top

Returns the toplevel directory if the current directory is inside a git view working directory.

####  git-track `?-n?` `<branch name>`

Sets tracking for a remote branch. This is useful when you create a new branch and
want it to be a public branch since the very beginning. If this is a local branch
only to be turned into a public branch, use `-n` option (otherwise it creates a local
branch tracked to a public branch).

####  git-tripconfig

Displays the full git configuration (everything, not just a configuration from the current repo)
in the TRIP format.

####  gvimdiff-git-wrapper

This is a much better than original diff tool using gvim (or vim, if gvim cannot be used). It handles
much better first of all the differences only in rights, added and deleted files. See the file itself
for an instruction how to make this script handle your 'git difftool' calls.

####  patch-distill.tcl

See git-distill-patch.


