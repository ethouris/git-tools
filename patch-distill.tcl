#!/usr/bin/tclsh


# Use [lassign] in Tcl 8.5
proc mset {vars list} { uplevel [list foreach $vars $list break] }

mset {overlay patch} $argv


if { $overlay == "" } {
    puts stderr "Usage: [file tail $argv0] <patch overlay> ?raw patch=cin? (distilled patch printed to cout)"
    exit 1
}

if { ![file readable $overlay] } {
    puts stderr "error: The overlay patch '$overlay' can't be open for reading."
    exit 1
}

if { $patch == "" } {
    set fd stdin
} else {
    set fd [open $patch r]
}

# Execute diff and pass the patch to stdin (overlay patch is passed as filename)
set erc [catch {exec diff - $overlay << [read $fd]} patch2]
set ecode $errorCode
set einfo $errorInfo
set lines [split $patch2 \n]

# Diff returns exit code 1 if files differ (but the process succeded)
# Make an error-to-expected-code fallback for Tcl, as Tcl treats nonzero code as error.
if { $erc } {
    mset {statkey pid status} $ecode
    
    if { $statkey == "CHILDSTATUS" } {
        if { $status == 1 } {
            # Just there are difs. Remove the last line that says 'child status failed' or something
            set lines [lrange $lines 0 end-1]
        } else {
            puts stderr "diff: diff could not open file (strange!)"
            exit 1
        }
    } else {
        error "(propagated)\n$einfo"
    }
}

# Now make an integrate of patch2 into a distilled patch (extract changes only)
set outlines ""

foreach l $lines {
    if { [string index $l 0] == "<" } {
        lappend outlines [string range $l 2 end]
    }
}

puts [join $outlines \n]

