# CMake build control file for Library Status

cmake_minimum_required(VERSION 2.8.12)

project("LibraryStatus" CXX)

#
# Compiler settings - special settings for known compilers
#

message(STATUS "compiler is ${CMAKE_CXX_COMPILER_ID}" )

if( CMAKE_CXX_COMPILER_ID STREQUAL "GNU" )
  add_definitions( -ftemplate-depth=300 )
elseif( CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" )
  add_definitions( /wd4996 )
elseif( CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" )
  add_definitions( -ftemplate-depth=300 )
  # include the following if and only if you want to use c++11 features
  set (CMAKE_CXX_FLAGS_DEBUG "-g -O0" )
  set (CMAKE_CXX_FLAGS_RELWITHDEBINFO "-g -O3" )
  set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -dead_strip")
endif()

#
# IDE settings
#

if( CMAKE_HOST_APPLE )
  # note: it seems that bjam builds both address models in any case
  # so we can defer this decision to the IDE just as we do for debug/release
  # so we'll not use this now
  # set(Boost_ADDRESS_MODEL 64 CACHE INTEGER "32/64 bits")
  set(Boost_USE_STATIC_LIBS ON CACHE BOOL "Link to Boost static libraries")
  set(Boost_USE_MULTITHREADED ON)
else()
  set(Boost_ADDRESS_MODEL 64 CACHE INTEGER "32/64 bits")
  set(Boost_USE_STATIC_LIBS ON CACHE BOOL "Link to Boost static libraries")
  set(Boost_USE_MULTITHREADED ON)
endif()

# Locate Project Prerequisites 
#

# Boost

# note: we're assuming that boost has been built with:
# ./b2 —-layout=versioned toolset=clang-darwin link=static,shared variant=debug,release stage

###########################
# special notes for Xcode.

# these three should result in CMake setting the variables
# Boost_SERIALIZATION_LIBRARY_DEBUG … to the correct values.  

# But my current version of CMake doesn't automatically set the library names
# to point to the the libraries to be used.  The variables are created
# but they are not initialized.  So be prepared to set these variables by hand.
# If you want to use the static libraries - point to the boost libraries ending
# in ".a".  If you want to use the shared boost libraries - point to the libraries
# ending in ".dylib".

# But wait - there's more.
# if both lib.a and lib.dylib both exist in the library directory, Xcode will
# automatically chose the *.dylib one - and there's nothing you can do to fix this.
# So my recommendation is 
# a) to place the compiled libraries in two different directories
#    - e.g. stage/lib-static/*.a and stage/lib-shared/*.dylib
#    and set the CMake variable Boost_LIBRARY_DIR to point to one or the other
# b) create two different CMake build directories - build-static and build-shared
#    and switch between the generated projects as desired.  I like to test both since
#    there are things like dead code elimination and visibility which vary
#    between the two environments.
#
#    caveat - as I write this, I've been unable to get the tests on the shared
#    library to function. Problem is that one needs to either put the shared
#    libraries in a special known place or set an environmental
#    variable which points to the shared library directory.  I prefer the latter
#    but I've been unable to figure out how to get Xcode to do on a global basis
#    and it's not practical to do this for 247 test targets one at a time.

# c) The targets in the project will by default be built as universal 32/64 binaries
#    in debug mode.  When working with the  

# end special note for Xcode
############################

find_package(Boost REQUIRED COMPONENTS system filesystem)

if(Boost_FOUND)
    message(STATUS "Boost is ${BOOST_ROOT}")
    message(STATUS "Boost directories found at ${Boost_INCLUDE_DIRS}")
    message(STATUS "Boost libraries found at ${Boost_LIBRARY_DIRS}")
    message(STATUS "Boost component libraries to be linked are ${Boost_LIBRARIES}")
    message(STATUS "Boost version found is ${Boost_VERSION}")
    include_directories("../include" "${Boost_INCLUDE_DIRS}")
    link_directories("${Boost_LIBRARY_DIRS}")
elseif()
    message("Boost NOT Found!")
endif()

if(Boost_USE_STATIC_LIBS)
  set(BUILD_SHARED_LIBRARIES OFF)
else()
  set(BUILD_SHARED_LIBRARIES ON)
endif()

#
# Project settings
#

find_package(Boost COMPONENTS filesystem system REQUIRED)

if(Boost_FOUND)
  message(STATUS "Boost is ${BOOST_ROOT}")
  set(Boost_USE_MULTITHREADED ON)
  set(Boost_USE_STATIC_LIBS ON CACHE BOOL "Link to Boost static libraries")
  # note: it seems that boost builds builds both address models in any case
  # so we can defer this decision to the IDE just as we do for debug/release
  # so we'll not use this now
  # set(Boost_ADDRESS_MODEL 64 CACHE INTEGER "32/64 bits")
  if( CMAKE_HOST_APPLE )
    set(Boost_ADDRESS_MODEL 64 CACHE INTEGER "32/64 bits")
  endif()
  message(STATUS "Boost is ${BOOST_ROOT}")
  message(STATUS "Boost directories found at ${Boost_INCLUDE_DIRS}")
  message(STATUS "Boost libraries found at ${Boost_LIBRARY_DIRS}")
  message(STATUS "Boost component libraries to be linked are ${Boost_LIBRARIES}")
  message(STATUS "Boost version found is ${Boost_VERSION}")
  if(Boost_USE_STATIC_LIBS)
    set(BUILD_SHARED_LIBRARIES OFF)
  else()
    set(BUILD_SHARED_LIBRARIES ON)
  endif()
  message(STATUS "Boost Libraries used are: ${Boost_LIBRARIES}" )
elseif()
    message("Boost NOT Found!")
endif()

link_directories("${Boost_LIBRARY_DIRS}")

###########################
# executable builds

add_library ( tiny_xml ../src/detail/tiny_xml.cpp)

add_executable( process_jam_log ../src/process_jam_log.cpp)
target_link_libraries(process_jam_log tiny_xml ${Boost_LIBRARIES})

add_executable( library_status ../src/library_status.cpp)
target_link_libraries(library_status tiny_xml  ${Boost_LIBRARIES})

# end library_status
###########################

