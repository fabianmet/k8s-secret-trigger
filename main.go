package main

import (
	"fmt"

	"github.com/fsnotify/fsnotify"
	"os"
)

func main() {

	// creates a new file watcher
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		fmt.Println("ERROR", err)
	}
	defer watcher.Close()

	//
	done := make(chan bool)

	//
	go func() {
		for {
			select {
			// watch for events
			case event := <-watcher.Events:
                                fmt.Println("FILES CHANGES FOUND!! AAAAHHH!!!")
				os.Exit(0)

				// watch for errors
			case err := <-watcher.Errors:
				fmt.Println("ERROR", err)
			}
		}
	}()

	if err := watcher.Add("/triggerfiles"); err != nil {
		fmt.Println("ERROR", err)
	}

	<-done
}
