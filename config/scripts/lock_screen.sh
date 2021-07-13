#!/bin/sh -e

# Take a screenshot
scrot /tmp/screen_locked.png

# Pixellate it 10x
convert /tmp/screen_locked.png -scale 5% -scale 2000% /tmp/screen_locked2.png
mv /tmp/screen_locked2.png /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock -i /tmp/screen_locked.png
