# Bijan Sondossi
# cmake/Helpers.cmake

##
#  @brief Forces the default value of a variable using caching.
#
#  @param var   The variable to set.
#  @param type  The type of the variable.
#  @param value The value to apply.
#
macro(force var type value)
  set(${var} ${value} CACHE ${type} "" FORCE)
endmacro()

##
#  @brief Forces the default value of a boolean variable using caching.
#
#  @param var   The variable to set.
#  @param value The value to apply.
#
macro(force_bool var value)
  force(${var} BOOL ${value})
endmacro()

##
#  @brief Forces the default value of an option using caching.
#
#  @param option The option to set.
#  @param value  The value to apply.
#
#  @remark Check defaults settings using `cmake -L ..` in the build
#          build directory.
#
macro(force_option option value)
  force_bool(${option} ${value})
endmacro()

##
#  @brief Adds a subdirectory if the target does not exist.
#
#  @param dir    The directory location.
#  @param target The targt to check.
#
macro(add_target_subdirectory dir target)
  if(NOT TARGET ${target})
    add_subdirectory(${dir})
  endif()
endmacro()

##
#  @brief Adds a directory if we are the CMAKE_SOURCE_DIR
#
#  @param dir  The directory location.
#  @param dest The build directory destination.
#
macro(add_root_subdirectory dir dest)
  if(${CMAKE_SOURCE_DIR} STREQUAL ${PROJECT_SOURCE_DIR})
    add_subdirectory(${dir} ${dest})
  endif()
endmacro()

##
#  @brief Adds a test and creates an executable.
#
#  @param name The executable/test to add.
#  @param file The test source file.
#  @param ARGN The targets to link.
#
macro(add_test_w_libs name file)
  add_test(
    NAME ${name}
    COMMAND ${name}
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  )

  add_executable(${name} ${file})

  set(args ${ARGN})
  list(LENGTH args args_size)
  if(${args_size} GREATER 0)
    target_link_libraries(${name} ${ARGN})
  endif()
endmacro()

##
#  @brief add_test_with_libs wrapper for gtest tests.
#
#  @param name The executable to build.
#  @param file The test source file.
#  @param ARGN The targets to link.
#
macro(add_gtest_w_libs name file)
  add_test_w_libs(${name} ${file} gtest gtest_main ${ARGN})
endmacro()

##
#  @brief add_test wrapper for gtests.
#
#  @param name The executable to build.
#  @param file The test source file.
#  @param ARGN Other sources.
#
macro(add_gtest name file)
  add_test(
    NAME ${name}
    COMMAND ${name}
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  )

  add_executable(${name} ${file} ${ARGN})

  target_link_libraries(${name} gtest gtest_main)
endmacro()

##
#  @brief Adds the /std:c++latest compiler flag.
#  @todo See if there is a better way to do this.
#
macro(msvc_std_latest)
  if(MSVC)
    set(
      ALL_CMAKE_CXX_FLAGS
      CMAKE_CXX_FLAGS
      CMAKE_CXX_FLAGS_DEBUG
      CMAKE_CXX_FLAGS_RELEASE
    )

    foreach(flag ${ALL_CMAKE_CXX_FLAGS})
      set(${flag} "${${flag}} /std:c++latest")
    endforeach()
  endif()
endmacro()

##
#  @brief Changes the default Visual Studio compiler flags to static
#         version of the run-time library.
#
macro(msvc_static_runtime)
  if(MSVC)
    # https://stackoverflow.com/questions/14172856

    set(
      ALL_CMAKE_CXX_FLAGS
      CMAKE_CXX_FLAGS
      CMAKE_CXX_FLAGS_DEBUG
      CMAKE_CXX_FLAGS_RELEASE
    )

    foreach(flag ${ALL_CMAKE_CXX_FLAGS})
      string(REGEX REPLACE "/MD" "/MT" ${flag} "${${flag}}")
    endforeach()
  endif()
endmacro()

##
#  @brief Links libraries to target marking header files as system
#         headers to suppress warnings.
#
#  @param target The target to link against.
#  @param ARGN The libraries to mark and link.
#
#  @see   https://stackoverflow.com/questions/51816807
#
function(target_link_libraries_system target)
  set(libs ${ARGN})
  foreach(lib ${libs})
    get_target_property(
      lib_include_dirs ${lib} INTERFACE_INCLUDE_DIRECTORIES)
    target_include_directories(
      ${target} SYSTEM PRIVATE ${lib_include_dirs})
    target_link_libraries(${target} ${lib})
  endforeach(lib)
endfunction(target_link_libraries_system)

# end Helpers.cmake
