#!/bin/env tclsh

package require Tk

namespace eval tcl_tickle {
	proc getTestName test {
		return [lindex $test 0]
	}

    if {![file exists test.tcl]} {
	    error "Missing test.tcl!"
    }
    
    source test.tcl

	if {[string length [info command unit]] <= 0} {
		error "No declaration for `unit`! (needs to return 'true' or 'false <reason>')"
	}

	if {![info exists list_of_tests]} {
		error "No declaration for `list_of_tests`!"
	}

	variable list_of_distests {}
	variable list_of_entests {}
	foreach test $list_of_tests {
		lappend list_of_entests [getTestName $test]
	}

	namespace eval gui {
		proc addTest {} {
			variable idx [.distestlist curselection]
			if {$idx eq ""} {
				return
			}
			foreach index $idx {
				variable test_name [.distestlist get $index]
				.distestlist delete $index
				.entestlist insert 0 $test_name
			}
		}

		proc removeTest {} {
			variable idx [.entestlist curselection]
			if {$idx eq ""} {
				return
			}
			foreach index $idx {
				variable test_name [.entestlist get $index]
				.entestlist delete $index
				.distestlist insert 0 $test_name
			}
		}

        proc getIndex {dalist strindex} {
            foreach test $dalist {
                if {[lindex $test 0] eq $strindex} {
                    return $test
                }
            }
            puts $dalist
            error "No such test found! (WTF????)"
        }

		proc runTests {} {
		    variable logs [open tcl_tickle.log w]
		    variable all_tests [.entestlist get 0 [.entestlist index end]]
			foreach test $all_tests {
			    variable res [::tcl_tickle::unit [getIndex $::tcl_tickle::list_of_tests $test]]
				if {[lindex $res 0]} {
				    puts "$test \x1b\[38;2;0;255;0m\[OK\]\x1b\[0m"
				    puts $logs "\[INFO\] $test \[OK\]"
				} else {
				    puts "$test \x1b\[38;2;255;0;0m\[KO\]\x1b\[0m"
				    puts $logs "\[ERROR\] $test \[KO\]"
				    if {[lindex $res 1] ne ""} {
				        puts [lindex $res 1]
				        puts $logs "\[ERROR\] [lindex $res 1]"
				    }
				}
			}
			close $logs
		}

		proc reloadTests {} {
		    namespace eval ::tcl_tickle [list source test.tcl]
		}
	
		grid [listbox .entestlist -listvariable ::tcl_tickle::list_of_entests]\
			[listbox .distestlist -listvariable ::tcl_tickle::list_of_distests]\
			[label .enlabel  -text "Enabled"]\
			[label .dislabel -text "Disabled"]\
			[button .enbutton  -text "Enable test" -command ::tcl_tickle::gui::addTest]\
			[button .disbutton -text "Disable test" -command ::tcl_tickle::gui::removeTest]\
			[button .runbutton -text "Run!" -command ::tcl_tickle::gui::runTests]\
			[button .reloadbutton -text "Reload" -command ::tcl_tickle::gui::reloadTests] -sticky news
		grid configure .enlabel -row 1 -column 1
		grid configure .dislabel -row 1 -column 2
		grid configure .entestlist -row 2 -column 1
		grid configure .distestlist -row 2 -column 2
		grid configure .enbutton -row 3 -column 1
		grid configure .disbutton -row 3 -column 2
		grid configure .runbutton -row 4 -column 1 -columnspan 2
		grid configure .reloadbutton -row 5 -column 1 -columnspan 2
		grid columnconfigure . 1 -weight 1
		grid columnconfigure . 2 -weight 1
	}
}
