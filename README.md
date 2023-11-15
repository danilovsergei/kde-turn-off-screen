# Description
It's a systemd service which runs in background. It listens for screen lock dbus events and \
turns off the monitor screen each time screen locked (either manually or automatically).

I created and use it with LG OLED TV to prevent burn in but will work the same with OLED monitors and laptops.

Service works both on X11 and Wayland.\
It's much more useful on wayland though because KDE lock screen always displays mouse cursor\
and there is no way to hide it.

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
Run the install.sh below that will install [kde-turn-off-screen](https://github.com/danilovsergei/kde-turn-off-screen/releases/latest/download/kde-turn-off-screen) into "$HOME/bin" or provide your own bin dir.\
It will also download and start [kde-turn-off-screen.service](https://github.com/danilovsergei/kde-turn-off-screen/releases/latest/download/kde-turn-off-screen.service) systemd user service with correct bin dir location your provided.

```
bash -c "$(curl -L https://raw.githubusercontent.com/danilovsergei/kde-turn-off-screen/main/install.sh)" -- "$HOME/bin"
```
That's it! service is ready to use.

Or manually:
* download latest [kde-turn-off-screen](https://github.com/danilovsergei/kde-turn-off-screen/releases/latest/download/kde-turn-off-screen) binary and save it to your scripts dir\
* download systemd user service [kde-turn-off-screen.service](https://github.com/danilovsergei/kde-turn-off-screen/releases/latest/download/kde-turn-off-screen.service) and edit ExecStart to provide full kde-turn-off-screen path
* start kde-turn-off-screen.service as a user
```
systemctl --user enable kde-turn-off-screen
systemctl --user start kde-turn-off-screen
```

