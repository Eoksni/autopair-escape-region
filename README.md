autopair-escape-region
==============

This package for Emacs was inspired by [auto-pair-plus][] which seems
to be abandoned and not working with latest autopair. But I love the
functionality of escaping inner quotes when quoting region so here is
a try to implement it as a separate package. 

[auto-pair-plus]: https://github.com/emacsmirror/auto-pair-plus

Dependencies
==============

`autopair`

Installation
==============

Add `(require 'autopair-escape-region)` to your initialization file.

Enjoy
==============

When `autopair-escape-region-when-quoting' (enabled by default) is
true, then it will appropriately quote the string. For example
selecting the following string:

`This is a test of the quoting system, "this is only a test"`

And pressing quote, gives:

`"This is a test of the quoting system, \"this is only a test\""`

Quoting the whole phrase again gives:

`"\"This is a test of the quoting system, \\\"this is only a test\\\"\""`
