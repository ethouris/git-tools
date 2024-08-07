#!/bin/bash
# Check and run with tclsh: \
if [[ -z "`type -p tclsh`" ]]; then echo You need tcl 8.5 to run this install and some of the tools.; exit 1; fi; exec tclsh "$0" "$@"

if { $argv == "" } {
	puts "Usage: INSTALL_ALL.sh <bin_prefix>"
	puts "(creates a symbolic link to all tools into the location of the repository)"
	exit 1
}


proc prelocate {path {wd .}} {

	if { $wd == "." } {
		set wd [pwd]
	} else {
		set wd [file normalize $wd]
	}

	set norm [file normalize $path]

	if { $norm == $wd } {
		return .
	}

	set common 0
	set norm_parts [file split $norm]
	set b_parts [file split $wd]
	set max [expr {max([llength $norm_parts],[llength $b_parts])}]
	while { [lindex $norm_parts $common] == [lindex $b_parts $common] } {
		incr common
		if { $common == $max } {
		        break
		}
	}

	set shift_norm_parts [lrange $norm_parts $common end]
	set overhead [expr {[llength $b_parts]-$common}]
	set uppath ""
	#$mkv::debug "Adding up-dir overhead: $overhead"
	if { $overhead > 0 } {
		set uppath [lrepeat $overhead ..]
	}
	set rpath [file join {*}$uppath {*}$shift_norm_parts]

	if { $rpath == "" } {
		return .
	}

	#$mkv::debug "Norma-localize in '$wd' $norm: $rpath"
	return $rpath
}

set prefix [lindex $argv 0]

if { ![file exists $prefix] } {
	puts "Prefix directory doesn't exist: $prefix"
	exit 1
}

set stack ""
while { [file type $prefix] == "link" } {
	lappend stack $prefix

	set WD [pwd]
	cd [file dirname $prefix]
	set fn [file tail $prefix]
	set prefix [file normalize [file readlink $fn]]
	cd $WD

	if { $prefix in $stack } {
		error "Prefix is a self-recursive link. Please supply a directory or a link to a directory."
	}
}

if { ![file isdirectory $prefix] } {
	puts "Prefix is not a directory: $prefix"
	exit 1
}


set TOOLS [glob {[a-z]*}]
set WD [pwd]

cd $prefix

set ninstalled 0
set nuptodate 0
set noverwritten 0
set ndenied 0


foreach tool $TOOLS {

	set path [file join $WD $tool]
	set tarpath [prelocate $path [pwd]]

	# This could be also a symbolic link to a nonexistent file.
	# There's no way to check that in Tcl because [file exists] will
	# always return 0 for such link, and there's also no [file islink].
	# There's one method to check it: check if the file is a link, and
	# catch the exception, which will be thrown when not even the link
	# exists.
	set notfound [catch {file type $tool} existtype]
	set islink 0
	set isdeadlink 0
	if { !$notfound } {

		# This will be set to true if the file is a symbolic link,
		# which points to either EXISTING or NONEXIETING file.
		set islink [expr {$existtype == "link"}]
	}

	#puts stderr "REPORT: '$tool' type '$existtype' failed:$notfound islink:$islink"

	if { $islink || !$notfound } {
		set type $existtype

		# Check if this is a symbolic link that points to a correct location.
		# If so, silently ignore it.
		if { $type == "link" } {
			set link [file readlink $tool]
			if { $link == $tarpath } {
				incr nuptodate
				continue
			}
			set type "link->$link"
			#puts "Link: $tool NOT TO $tarpath"
		}

		puts -nonewline "ERROR: the '$tool' tool ($type) already exists in the target directory. Overwrite? (y/N) "
		flush stdout
		set ans [gets stdin]
		if { $ans == "" } {
			set ans n
		}

		set ans [string tolower $ans]
		if { [string index $ans 0] == "y" } {
			file delete $tool
			incr noverwritten
		} else {
			incr ndenied
		}
	} else {
		incr ninstalled
	}

	file link -s $tool $tarpath
}

puts "INSTALLED $ninstalled files. $nuptodate were up-to-date, $noverwritten overwritten, $ndenied denied to overwrite."

# set ft=tcl
