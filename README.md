The purpose of this small script is to parse a .menu file (XDG / FreeDesktop.org compliance) and offer a main menu with submenu/categories to start an application using dmenu.

#####Requisites
(Made and tested only on Kali 2016.1 64-bit, but probably works with any .menu file)
- dmenu 
- bash 4+
- sed, head, tail, gawk, grep, tr, echo, find :P

#####Why?
There is [j4-dmenu-desktop](https://github.com/enkore/j4-dmenu-desktop) and a lot of other projects who parses .desktop files, but I couldn't find one that read .menu and .directory files, and generate a xdg menu like a DE normally does.

I use a tiling window manager (bspwm and occasionally i3wm), so this is necessary for me because sometimes I don't remember the name of a specific tool on kali.

#####Cool. Show me!
![](https://cloud.githubusercontent.com/assets/5271831/15392701/44bd5b26-1d9f-11e6-936c-a48da99ade40.gif)
