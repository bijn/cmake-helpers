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
#  @brief adds a subdirectory if we are the CMAKE_SOURCE_DIR
#
#  @param dir  The directory location.
#
macro(add_subdirectory_safe dir)
  if(${CMAKE_SOURCE_DIR} STREQUAL ${PROJECT_SOURCE_DIR})
    add_subdirectory(${dir})
  endif()
endmacro()

##
#  @brief adds a directory if we are the CMAKE_SOURCE_DIR
#
#  @param dir  The directory location.
#  @param dest The build directory destination.
#
macro(add_directory dir dest)
  if(${CMAKE_SOURCE_DIR} STREQUAL ${PROJECT_SOURCE_DIR})
    add_subdirectory(${dir} ${dest})
  endif()
endmacro()

# end Helpers.cmake

