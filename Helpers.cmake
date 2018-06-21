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
macro(add_subdirectory_safe dir target)
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
macro(add_directory dir dest)
  if(${CMAKE_SOURCE_DIR} STREQUAL ${PROJECT_SOURCE_DIR})
    add_subdirectory(${dir} ${dest})
  endif()
endmacro()

##
#  @brief Adds a test and creates an executable.
#
#  @param name The executable to build.
#  @param ARGN The targets to link.
#
macro(define_test name)
  add_test(
    NAME ${name}
    COMMAND ${name}
    WORKING_DIRECTORY ${UNIT_TEST_BIN_OUTPUT_DIR}
  )

  add_executable(${name} "${name}.cc")

  set(args ${ARGN})
  list(LENGTH args args_size)
  if(${args_size} GREATER 0)
    target_link_libraries(${name} ${ARGN})
  endif()
endmacro()

# end Helpers.cmake

