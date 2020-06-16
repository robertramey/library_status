# CMake build control file for Library Status

cmake_minimum_required(VERSION 3.0)

project("LibraryStatus")

#
# Compiler settings - special settings for known compilers
#

message(STATUS "compiler is ${CMAKE_CXX_COMPILER_ID}" )

if( CMAKE_CXX_COMPILER_ID STREQUAL "GNU" )
  add_definitions( -ftemplate-depth=255 )
elseif( CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" )
  add_definitions( /wd4996 )
elseif( CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" )
  add_definitions( -ftemplate-depth=255 )
  # include the following if and only if you want to use c++11 features
  set (CMAKE_CXX_FLAGS_DEBUG "-g -O0" )
  set (CMAKE_CXX_FLAGS_RELWITHDEBINFO "-g -O3" )
  set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -dead_strip")
endif()

# Locate Project Prerequisites

# Boost

# note: we're assuming that boost has been built with:
# ./b2 toolset=clang-darwin link=static,shared variant=debug,release stage

#
# Project settings
#

find_package(Boost 1.74 REQUIRED COMPONENTS system filesystem)

if(NOT Boost_FOUND)
  message("Boost NOT Found!")
elseif()
  message("Boost Found!")
endif()

###########################
# executable builds

add_library ( tiny_xml ../src/detail/tiny_xml.cpp)
target_include_directories(tiny_xml PUBLIC ${Boost_INCLUDE_DIR})

add_executable( process_jam_log ../src/process_jam_log.cpp)
target_link_libraries(process_jam_log PRIVATE tiny_xml Boost::system Boost::filesystem)

add_executable( library_status ../src/library_status.cpp)
target_link_libraries(library_status PRIVATE
  tiny_xml
  Boost::system
  Boost::filesystem
)

# end library_status
###########################
