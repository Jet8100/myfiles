#include <stdio.h>
#include <string.h>
#include <curses.h>

int main() {
    initscr(); // Start curses mode
    mvprintw(10, 10, "Hello, Curses!");
    refresh(); // Update screen
    getchar();
    endwin(); // End curses mode
    return 0;
}