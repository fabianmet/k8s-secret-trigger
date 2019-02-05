from watchdog.observers.polling import PollingObserver
from watchdog.events import PatternMatchingEventHandler
import sys
import time


## classes to handle continuous watching of config
class Watcher:

    def __init__(self, watchdir):
        self.observer = PollingObserver(timeout=1)
        self.watchdir = watchdir

    def run(self):
        event_handler = Handler()
        self.observer.schedule(event_handler, self.watchdir)
        self.observer.start()
        try:
            while True:
                time.sleep(5)
        except KeyboardInterrupt:
            self.observer.stop()
            print "Received SIGINT"
        except:
            self.observer.stop()
            print "Error"

        self.observer.join()


class Handler(PatternMatchingEventHandler):

    def on_any_event(self, event):
        if event.event_type == 'created' or event.event_type == 'modified':
		sys.exit("I SPOT A CHANGE! AAAAHHHH")


if __name__ == '__main__':

    w = Watcher("/app/statefiles")
    w.run()
