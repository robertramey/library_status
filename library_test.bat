@echo off

rem Copyright Robert Ramey 2007

rem Distributed under the Boost Software License, Version 1.0.
rem See http://www.boost.org/LICENSE_1_0.txt

if not "%1" == "" goto b2
    echo Usage: %0 "<b2 arguments>"
    echo where typical b2 arguements are:
    echo   toolset=msvc-7.1,gcc
    echo   variant=debug,release,profile
    echo   link=static,shared
    echo   threading=single,multi
    echo   -sBOOST_ARCHIVE_LIST="<archive name>"
    goto end
:b2
    b2 --dump-tests %* >b2.log
    process_jam_log --v2 <b2.log
    library_status library_status.html links.html
:end
