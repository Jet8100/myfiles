# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################

set(pdcurses_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${pdcurses_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${pdcurses_COMPILE_OPTIONS_C_DEBUG}>")

set(pdcurses_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${pdcurses_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${pdcurses_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${pdcurses_EXE_LINK_FLAGS_DEBUG}>")

set(pdcurses_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(pdcurses_FRAMEWORKS_FOUND_DEBUG "${pdcurses_FRAMEWORKS_DEBUG}" "${pdcurses_FRAMEWORK_DIRS_DEBUG}")

set(pdcurses_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET pdcurses_DEPS_TARGET)
    add_library(pdcurses_DEPS_TARGET INTERFACE)
endif()

set_property(TARGET pdcurses_DEPS_TARGET
             PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${pdcurses_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${pdcurses_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>
             APPEND)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### pdcurses_DEPS_TARGET to all of them
conan_package_library_targets("${pdcurses_LIBS_DEBUG}"    # libraries
                              "${pdcurses_LIB_DIRS_DEBUG}" # package_libdir
                              pdcurses_DEPS_TARGET
                              pdcurses_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "pdcurses")    # package_name

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${pdcurses_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})


########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET pdcurses::pdcurses
                 PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${pdcurses_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${pdcurses_LIBRARIES_TARGETS}>
                 APPEND)

    if("${pdcurses_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET pdcurses::pdcurses
                     PROPERTY INTERFACE_LINK_LIBRARIES
                     pdcurses_DEPS_TARGET
                     APPEND)
    endif()

    set_property(TARGET pdcurses::pdcurses
                 PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${pdcurses_LINKER_FLAGS_DEBUG}> APPEND)
    set_property(TARGET pdcurses::pdcurses
                 PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${pdcurses_INCLUDE_DIRS_DEBUG}> APPEND)
    set_property(TARGET pdcurses::pdcurses
                 PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${pdcurses_COMPILE_DEFINITIONS_DEBUG}> APPEND)
    set_property(TARGET pdcurses::pdcurses
                 PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${pdcurses_COMPILE_OPTIONS_DEBUG}> APPEND)

########## For the modules (FindXXX)
set(pdcurses_LIBRARIES_DEBUG pdcurses::pdcurses)
