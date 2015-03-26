# Copyright Robert Ramey 2007

# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

if test $# -eq 0 
then
    echo "Usage: $0 <b2 arguments>"
    echo "Typical b2 arguements are:"
    echo "  toolset=msvc-7.1,gcc"
    echo "  variant=debug,release,profile"
    echo "  link=static,shared"
    echo "  threading=single,multi"
    echo "  -sBOOST_ARCHIVE_LIST=<archive name>"
else
    b2 --dump-tests $@ >b2.log 2>&1
    process_jam_log --v2 <b2.log
    library_status library_status.html links.html
fi
