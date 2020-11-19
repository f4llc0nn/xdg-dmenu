#!/bin/bash
# Author: @fallc0nn (github, twitter)
# Last Update: 23-Nov-2020
# Tested with Kali 2020.4 (Rolling Release), file "/etc/xdg/menus/applications-merged/kali-applications.menu"

dmenu_cmd="dmenu -i -l 25 -fn -xos4-terminus-medium-r-*-*-14-*"
menu_path="/etc/xdg/menus/applications-merged/kali-applications.menu"
apps_path="/usr/share/kali-menu/applications/" #Path of .desktop files.
menu_exceptions="Applications,Usual" #(Optional) Remove unused categories. If not required, use "None".
menu_prefix="+" #(Suggestion) Replace with fontAwesome icons
term_cmd="xfce4-terminal --hide-borders --hide-toolbar --hide-menubar -e"

## (1) Main menu list
menu_selected="$(grep "<Name>" "$menu_path" |grep -v "$(for e in $(echo $menu_exceptions |tr "," "\n"); do echo "Name>$e\|";done |sed "s/\\\|$//")" |sed "s/<\/\?Name>//g;s/^ \{4\}/$menu_prefix /" |grep -v "^$menu_prefix  " |$dmenu_cmd)"
[[ ! "$menu_selected" ]] && exit 1

## (2) Submenu list and it's tools:
menu_dir="$(grep -A1 "${menu_selected:${#menu_prefix}+1}" "$menu_path" |tail -1 |grep -Eo ">[^\.]+" |tr -d ">")"
submenu_selected="$({ grep "<Name>" "$menu_path" |grep -v "$(for e in $(echo $menu_exceptions |tr "," "\n"); do echo "Name>$e\|";done |sed "s/\\\|$//")" |sed "s/<\/\?Name>//g;s/^\ \{4\}/$menu_prefix /" |sed -n "/${menu_selected:${#menu_prefix}+1}/,/^$menu_prefix\ [^\ ]/p" |head -n -1 |tail -n +2 |sed "s/$menu_prefix \+/$menu_selected > /" |sort; for tool in $(grep -ir "Categories=.*$menu_dir" "$apps_path" |cut -d":" -f1); do grep "Name=" "$tool" |cut -d"=" -f2 ;done |sort; } |$dmenu_cmd)"
[[ ! "$submenu_selected" ]] && exit 1

## (3) If submenu, list it's tools. Else, execute tool:
[[ "$submenu_selected" =~ " > " ]] && {
    submenu_selected=$( awk -F " > " '{print $2}' <<< "$submenu_selected")
    submenu_dir="$(grep -A1 "${submenu_selected:${#menu_prefix}+1}" "$menu_path" |tail -1 |grep -Eo ">[^\.]+" |tr -d ">")"
    toolexec="$(for tool in $(grep -ir "Categories=.*$submenu_dir" "$apps_path" |cut -d":" -f1); do grep "Name=" "$tool" |cut -d"=" -f2 ;done |sort |$dmenu_cmd)"
    [[ ! "$toolexec" ]] && exit 1 || $term_cmd "$(find "$apps_path" -iname "*$toolexec*.desktop" -exec grep "Exec" {} \; |cut -d"=" -f2)"
} || {
    toolexec="$submenu_selected"
    $term_cmd "$(find "$apps_path" -iname "*$toolexec*.desktop" -exec grep "Exec" {} \; |cut -d"=" -f2)"
}
