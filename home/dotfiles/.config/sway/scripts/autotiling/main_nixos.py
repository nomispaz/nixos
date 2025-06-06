#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python311Packages.i3ipc

from i3ipc import Connection, Event

def change_layout(i3, e):
    # Get the name of the focused window
    focused = i3.get_tree().find_focused()
    print('Focused window %s is on workspace %s' %
          (focused.name, focused.workspace().name))

    # check if window layout is stacked or tabbed
    cWindowStacked = focused.parent.layout == "stacked"
    cWindowTabbed = focused.parent.layout == "tabbed"

    print(cWindowStacked, cWindowTabbed)


    # only change split direction if the window layout is not stacked or tabbed
    if (not cWindowTabbed and not cWindowStacked):

        
        # set layout(split horizontalor vertical according to geometry of current window)
        if focused.rect.height > focused.rect.width:
            new_layout = "splitv"
        else:
            new_layout = "splith"

        # Send the new command to be executed synchronously.
        i3.command(new_layout)


def main():
    # Create the Connection object that can be used to send commands and subscribe
    # to events.
    i3 = Connection()

    i3.on(Event.WINDOW_FOCUS, change_layout)

    # Start the main loop and wait for events to come in.
    i3.main()

if __name__ == "__main__":
    main()
