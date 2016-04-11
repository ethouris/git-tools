Git Tools
=========

This is a set of useful commands to help with `git`.

####  git-del `<repo-file>`

Alias to `git rm --cached`. Use that rather than `git rm`, which actually does `git rm --cached <repo-file> ; rm <repo-file>`.

####  git-distill-patch `<parent-branch> <patch-overlay-file>`

This is useful when you have some your own changes on the git repository view, which you'd like to preserve, but
you want to share all other your changes with the upstream. This tool allows you to create a patch that contains
all changes you have done in the repository, except the changes that you don't want to share. You have to make the
repository view the state as equal to the parent branch with only your private changes applied, and you should create
a PATCH file from the current state of differences. Save them into a file, which will be `<patch-overlay-file>`. Next
after you make extra changes, use git-distill-patch to create a patch containing all changes except those in the
patch overlay file. The results will be still for you to check: `PATCH` file will contain the complete patch, while
`PATCH.distilled` will contain the patch purged of your private changes. This script is only a forwarder, the whole
job will be done by `patch-distill.tcl` script.

####  git-getpin ?submodule-repo?

This returns the SHA1 code of the commit by which a submodule is pinned into the parent repository. Wihtout arguments
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

Files displayed with -o option have no header and no extra information, this option is
predicted to be used with additional pipe processing.

####  git-prefix

Returns the current working directory starting from the current git view working directory.

####  git-rolling-resolve

This tool is useful only for teams that use rebase-mode workflow. This does rebase and merge
in loop, until the rebase states that there are no more conflicts.

####  git-sp

This is a helper script for `git subtree`. It supplies automatically the --prefix option that
`git subtree` normally requires. Useful only if you use `git subtree` tool.

####  git-top

Returns the toplevel directory if the git view working directory.

####  git-track

Sets tracking for a remote branch. This is useful when you create a new branch and
want it to be a public branch since the very beginning.

####  git-tripconfig

Displays the full git configuration (everything, not just a configuration from the current repo)
in the TRIP format.

####  gvimdiff-git-wrapper

This is a much better than original diff tool using gvim (or vim, if gvim cannot be used). It handles
much better first of all the differences only in rights, added and deleted files. See the file itself
for an instruction how to make this script handle your 'git difftool' calls.

####  patch-distill.tcl

See git-distill-patch.
