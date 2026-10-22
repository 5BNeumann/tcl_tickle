# tcl_tickle

This is a small test """framework""" written in tcl.

It is more of a test manager to say the truth but oh well.

## Usage

To use it you need to create you own `test.tcl`, it must contain a `unit` proc that must be the test runner. It takes one argument, the test. It should return `true` in case of test success and `{false <reason>}` in case of failure.

The tests should be stored in a list of lists in the `list_of_tests` variable, the first value in each list being the test's name. The rest is up to you!

## Features

 - enable/disable tests
 - reload tests without stopping
 - running tests (shocking, I know)

## Roadmap

Nothing. Unless you open an issue with a good feature or a bug.
