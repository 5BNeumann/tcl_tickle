proc unit test {
    set test_content_file "./tcl_tickle_test.tmp"
    if {[file exists $test_content_file]} {
        file delete $test_content_file
    }
    variable tfile [open $test_content_file w]
    puts $tfile [lindex $test 1]
    close $tfile
    variable status [catch {exec [file join [file dirname [file normalize [info script]]] simplesed] $test_content_file [lindex $test 2] [lindex $test 3]}]
    variable rfile [open "${test_content_file}.replace" r]
    variable res [read $rfile]
	close $rfile
	if {$res eq [lindex $test 4]} {
	    return true
	} else {
	    return "false {got: '$res' expected: '[lindex $test 4]'}"
	}
}

set list_of_tests {{"Test 1" babibubebo ba bi bibibubebo} {"Test 2" b.a.ba a u b.u.bu}}
