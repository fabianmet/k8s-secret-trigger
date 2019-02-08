package main

import (
	"fmt"

	"github.com/fsnotify/fsnotify"
)

func main() {

	// creates a new file watcher
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		fmt.Println("ERROR", err)
	}
	defer watcher.Close()

	// Prepare the lifecycle channel
	done := make(chan bool)

	//
	go func(c chan bool) {
		for {
			select {
			// watch for events
			case event := <-watcher.Events:
				fmt.Printf("File %v has operation %v AAAAHHH!!!\n", event.Name, event.Op)
				done <- true

				// watch for errors
			case err := <-watcher.Errors:
				fmt.Println("ERROR", err)
			}
		}
	}(done)

	if err := watcher.Add("/triggerfiles"); err != nil {
		fmt.Println("ERROR", err)
	}

	<-done
}
