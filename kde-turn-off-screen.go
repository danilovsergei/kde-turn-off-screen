package main

import (
	"fmt"
	"log"
	"os"

	"github.com/godbus/dbus/v5"
)

func main() {
	startDbusSignalListener("type='signal',interface='org.freedesktop.ScreenSaver',path='/ScreenSaver',member='ActiveChanged'")
}

// Starts dbus listener for ActiveChanged method changes in /ScreenSaver
func startDbusSignalListener(signal string) {
	conn, err := dbus.SessionBus()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Failed to connect to session bus:", err)
		os.Exit(1)
	}
	// creates dbus matcher for specified signal
	call := conn.BusObject().Call("org.freedesktop.DBus.AddMatch", 0, signal)

	if call.Err != nil {
		log.Printf("Dbus connection error: %s \n", call.Err)
	}

	c := make(chan *dbus.Signal, 10)
	conn.Signal(c)
	for signal := range c {
		locked := signal.Body[0].(bool)
		if locked {
			lockScreen(conn)
		}
	}
}

// Locks the screen using kde "Turn Off Screen" shortcut
// Equivalent of qdbus org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut "Turn Off Screen"
func lockScreen(conn *dbus.Conn) {
	log.Println("Turn off the screen on screen lock event")
	kglobalaccel := conn.Object("org.kde.kglobalaccel", "/component/org_kde_powerdevil")
	resp := kglobalaccel.Call("invokeShortcut", 0, "Turn Off Screen")
	if resp.Err != nil {
		log.Printf("Failed Turn off the screen %s\n", resp.Err)
	}
}
