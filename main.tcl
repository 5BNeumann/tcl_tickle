#!/bin/env tclsh

package require Tk

namespace eval tcl_tickle {
	proc fallback_testname test {
		puts test
	}

	if {![file exists test.tcl]} {
		error "Missing test.tcl!"
	}

	source test.tcl

	if {[string length [info command unit]] <= 0} {
		error "No declaration for `unit`!"
	}

	if {![info exists list_of_tests]} {
		error "No declaration for `list_of_tests`!"
	}

	variable gtn ::tcl_tickle::fallback_testname
	if {[string length [info command testname]] > 0} {
		variable gtn testname
	} else {
		puts "WARNING: No definition was found for `list_of_tests`!"
	}

	variable list_of_distests {}
	variable list_of_entests {}
	foreach test $list_of_tests {
		lappend list_of_entests [$gtn $test]
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

		proc runTests {} {
			foreach test [.entestlist get 0 [.entestlist index end]] {
				
			}
		}
	
		grid [listbox .entestlist -listvariable ::tcl_tickle::list_of_entests]\
			[listbox .distestlist -listvariable ::tcl_tickle::list_of_distests]\
			[button .enbutton  -text "Enable test" -command ::tcl_tickle::gui::addTest]\
			[button .disbutton -text "Disable test" -command ::tcl_tickle::gui::removeTest]\
			[button .runbutton -text "Run!" -command ::tcl_tickle::gui::runTests] -sticky news
		grid configure .entestlist -row 1 -column 1
		grid configure .distestlist -row 1 -column 2
		grid configure .enbutton -row 2 -column 1
		grid configure .disbutton -row 2 -column 2
		grid columnconfigure . 1 -weight 1
		grid columnconfigure . 2 -weight 1
	}
}
