cmake_minimum_required(VERSION 3.23)
project(untitled1 C)

set(CMAKE_C_STANDARD 99)

find_package(pdcurses)

add_executable(untitled1 main.c)
target_link_libraries(untitled1 pdcurses::pdcurses)