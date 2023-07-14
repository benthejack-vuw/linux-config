#!/bin/zsh

selection=$(echo "Ben\nAkqa\nZimmer-Biomet" | rofi -dmenu -i)
profile=$(echo $selection | awk '{print $1;}')
count=$(echo $selection | awk '{print $2;}')

open_profile()
{
    case $1 in
        Ben) brave-browser --profile-directory="Default" --new-window;;
        Akqa)  brave-browser --profile-directory="Profile 1" --new-window;;
        Zimmer-Biomet)  brave-browser --profile-directory="Profile 2" --new-window;;
    esac
}

open_profile_n_times()
{
    if [ -z $2 ]; then
        open_profile $1
    else
        repeat $2 { open_profile $1 }
    fi
}

open_profile_n_times $profile $count