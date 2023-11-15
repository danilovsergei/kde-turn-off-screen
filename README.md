# Description
It's systemd service which runs in background.\
It turns off the monitor screen each time screen locked (either manually or automatically).

I created and use it with LG OLED TV to prevent burn in but will work the same with OLED monitors and laptops.

Service works both on X11 and Wayland.\
It's much more useful on wayland though because KDE lock screen always displays mouse cursor\
and there is no way to hide it

# Limitations
Service works only in kde because it uses kde powerdevil to turn off the screen.\
Basically that call

```
qdbus org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut "Turn Off Screen"
```


# Usage
My use case is to typically press hotkey to lock the screen which triggers turning off the screen as well\
I also have automatic screen lock in KDE setup , which also triggers screen turn off in case i forgot to lock.

# Installation