# Copyright (c) 2010, 2012, 2014 roger
# Copyright (c) 2011 Kirk Strauser
# Copyright (c) 2011 Florian Mounier
# Copyright (c) 2011 Mounier Florian
# Copyright (c) 2011 Roger Duran
# Copyright (c) 2012-2015 Tycho Andersen
# Copyright (c) 2013 Tao Sauvage
# Copyright (c) 2013 Craig Barnes
# Copyright (c) 2014-2015 Sean Vig
# Copyright (c) 2014 Adi Sieker
# Copyright (c) 2014 dmpayton
# Copyright (c) 2014 Jody Frankowski
# Copyright (c) 2016 Christoph Lassner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import subprocess

from libqtile import bar
from libqtile.command.base import expose_command
from libqtile.widget import base

__all__ = [
    "Mic",
]

class Mic(base._TextBox):
    "Widget that display and change status of microphone using wpctl."

    orientations = base.ORIENTATION_HORIZONTAL

    defaults = [
        ("padding", 3, "Padding left and right. Calculated if None."),
        ("update_interval", 1.0, "Update time in seconds."),
        ("mute_command", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", "Mute command"),
        ("volume_app", "pavucontrol", "App to control volume"),
        (
            "get_volume_command",
            "wpctl get-volume @DEFAULT_AUDIO_SOURCE@",
            "Command to get the current volume. "
        ),
        ("check_mute_command", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@", "Command to check mute status"),
        (
            "check_mute_string",
            "[MUTED]",
            "String expected from check_mute_command when volume is muted."
            "When the output of the command matches this string, the"
            "audio source is treated as muted.",
        ),
    ]

    def __init__(self, **config):
        base._TextBox.__init__(self, "0", **config)
        self.add_defaults(Mic.defaults)
        self.surfaces = {}
        self.volume = None

        self.add_callbacks(
            {
                "Button1": self.mute,
                "Button3": self.run_app,
            }
        )
    
    def _configure(self, qtile, parent_bar):
        base._TextBox._configure(self, qtile, parent_bar)

    def timer_setup(self):
        self.timeout_add(self.update_interval, self.update)

    def button_press(self, x, y, button):
        base._TextBox.button_press(self, x, y, button)
        self.draw()

    def update(self):
        vol = self.get_volume()
        if vol != self.volume:
            self.volume = vol
            # Update the underlying canvas size before actually attempting
            # to figure out how big it is and draw it.
            self._update_drawer()
            self.bar.draw()
        self.timeout_add(self.update_interval, self.update)

    def _update_drawer(self):
        if self.volume == -1:
            self.text = ""
        else:
            self.text = " {}%".format(self.volume)
            
    def get_volume(self):
        try:
            get_volume_cmd = self.get_volume_command
            mixer_in = subprocess.getoutput(get_volume_cmd).lstrip("Volume: ").replace(".","").lstrip("0")
        
        except subprocess.CalledProcessError:
            return -1

        check_mute = mixer_in

        if self.check_mute_command:
            check_mute = subprocess.getoutput(self.check_mute_command)[12:]

        if self.check_mute_string in check_mute:
            return -1

        return int(mixer_in)

    def draw(self):
        base._TextBox.draw(self)

    @expose_command()
    def mute(self):
        mute_cmd = self.mute_command
        
        subprocess.call(mute_cmd, shell=True)

    @expose_command()
    def run_app(self):
        if self.volume_app is not None:
            subprocess.Popen(self.volume_app, shell=True)
