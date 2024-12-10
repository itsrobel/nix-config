# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
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

import os
import subprocess

computer_type = subprocess.run(
    ["./comp-type.sh"], stdout=subprocess.PIPE, shell=True, text=True
).stdout

# from qtile_extras.widget import StatusNotifier
import colors
from libqtile import bar, hook, layout, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import logger
from libqtile.widget import backlight

# Make sure 'qtile-extras' is installed or this config will not work.
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

mod = "mod4"  # Sets mod key to SUPER/WINDOWS
myTerm = "kitty -e tmux"  # My terminal of choice
myBrowser = "firefox"  # My browser of choice
myRun = "rofi -show run"  # My application launcher


# Allows you to input a name when adding treetab section.
@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)


# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


# A function for toggling between MAX and MONADTALL layouts

keys = [
    # The essentials
    Key([mod], "Return", lazy.spawn(myTerm), desc="Terminal"),
    # Key([mod, "shift"], "Return", lazy.spawn("rofi -show drun"), desc="Run Launcher"),
    Key(
        [mod, "shift"],
        "c",
        lazy.spawn(
            'rofi -modi "clipboard:greenclip print" -show clipboard -run-command "{cmd}"'
        ),
        desc="show clipboard history",
    ),
    Key([mod], "g", lazy.spawn(myBrowser), desc="Web browser"),
    Key([mod], "p", lazy.spawn(myRun), desc="Run Launcher"),
    # Key([mod], "e", lazy.spawn(myEditor), desc="Text editor"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    # Key([mod, "shift"], "x", lazy.spawn("archlinux-logout"), desc="Logout menu"),
    Key([mod, "shift"], "x", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "n", lazy.layout.reset(), desc="Reset all window sizes"),
    Key([mod], "m", lazy.layout.maximize(), desc="Toggle between min and max sizes"),
    Key([mod], "k", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod], "j", lazy.layout.previous(), desc="Move window focus to other window"),
    Key(
        [mod, "shift"], "j", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod], "space", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod, "control"], "l", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod, "control"], "h", lazy.prev_screen(), desc="Move focus to prev monitor"),
    Key(
        [mod],
        "comma",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "period",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key([], "XF86AudioRaiseVolume", lazy.widget["volume"].increase_vol()),
    Key([], "XF86AudioLowerVolume", lazy.widget["volume"].decrease_vol()),
    Key([], "XF86AudioMute", lazy.widget["volume"].mute()),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.UP),
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.DOWN),
    ),
]

groups = []
group_names = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
]

group_labels = [
    "DEV",
    "WWW",
    "DOC",
    "ZEN",
    "VID",
    "SYS",
    "TEL",
    "OBS",
    "MUS",
]
# group_labels = ["", "", "", "", "", "", "", "", "",]

group_layout = "monadtall"
for i in range(len(group_names)):
    groups.append(
        Group(
            layout=group_layout,
            label=group_labels[i] + f" ({group_names[i]})",
            name=group_names[i],
        )
    )

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

colors = colors.DoomOne

layout_theme = {
    "border_width": 2,
    "margin": 16,
    "border_focus": colors[8],
    "border_normal": colors[0],
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Columns(**layout_theme),
]

widget_defaults = dict(font="Ubuntu Bold", fontsize=12, padding=0, background=colors[0])

extension_defaults = widget_defaults.copy()


# computer_type = subprocess.run(["./comp-type.sh"], stdout=subprocess.PIPE, shell=True)
logger.warning("Computer type: " + computer_type)

computer_type = subprocess.run("laptop-detect", shell=True).returncode

if computer_type == 0:
    logger.warning("is laptop")


# print(subprocess.run("laptop-detect", shell=True).stdout)


def init_widgets_list():
    widgets_list = [
        widget.Image(
            filename="~/.config/qtile/icons/python-white.png",
            scale="False",
            mouse_callbacks={"Button1": lambda: qtile.spawn(myTerm)},
        ),
        widget.Prompt(font="Ubuntu Mono", fontsize=14, foreground=colors[1]),
        widget.GroupBox(
            fontsize=11,
            margin_y=5,
            margin_x=5,
            padding_y=0,
            padding_x=1,
            borderwidth=3,
            active=colors[8],
            inactive=colors[1],
            rounded=False,
            highlight_color=colors[2],
            highlight_method="line",
            this_current_screen_border=colors[7],
            this_screen_border=colors[4],
            other_current_screen_border=colors[7],
            other_screen_border=colors[4],
        ),
        widget.TextBox(
            text="|",
            font="Ubuntu Mono",
            foreground=colors[1],
            padding=2,
            fontsize=14,
        ),
        widget.CurrentLayoutIcon(
            # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[1],
            padding=4,
            scale=0.6,
        ),
        widget.CurrentLayout(foreground=colors[1], padding=5),
        widget.TextBox(
            text="|",
            font="Ubuntu Mono",
            foreground=colors[1],
            padding=2,
            fontsize=14,
        ),
        widget.WindowName(foreground=colors[6], max_chars=40),
        widget.GenPollText(
            update_interval=300,
            func=lambda: subprocess.check_output(
                "printf $(uname -r)", shell=True, text=True
            ).upper(),
            foreground=colors[3],
            fmt="❤  {}",
            decorations=[
                BorderDecoration(
                    colour=colors[3],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.CPU(
            format="   CPU: {load_percent}%",
            foreground=colors[6],
            decorations=[
                BorderDecoration(
                    colour=colors[6],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        # widget.CPUGraph(
        #     graph_color=colors[6],
        #     border_color=colors[6],
        #     type="line",
        #     decorations=[
        #         BorderDecoration(
        #             colour=colors[6],
        #             border_width=[0, 0, 2, 0],
        #         )
        #     ],
        # ),
        widget.Spacer(length=8),
        widget.Memory(
            foreground=colors[8],
            mouse_callbacks={"Button1": lambda: qtile.spawn(myTerm + " -e htop")},
            # format="{MemUsed: .0f}{mm}",
            fmt="🖥  MEM: {}",
            decorations=[
                BorderDecoration(
                    colour=colors[8],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.DF(
            update_interval=60,
            foreground=colors[5],
            mouse_callbacks={"Button1": lambda: qtile.spawn(myTerm + " -e df")},
            partition="/",
            # format = '[{p}] {uf}{m} ({r:.0f}%)',
            format="{uf}{m} free",
            fmt="🖴  DSK: {}",
            visible_on_warn=False,
            decorations=[
                BorderDecoration(
                    colour=colors[5],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.Volume(
            foreground=colors[7],
            fmt="   VOL: {}",
            decorations=[
                BorderDecoration(
                    colour=colors[7],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.KeyboardLayout(
            foreground=colors[3],
            fmt="⌨  KBD: {}",
            decorations=[
                BorderDecoration(
                    colour=colors[3],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.Clock(
            foreground=colors[8],
            # format="⏱  %A, %b %d - %H:%M",
            format="⏱  %H:%M",
            decorations=[
                BorderDecoration(
                    colour=colors[8],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
    ]
    return widgets_list


def init_systray():
    systray = [
        widget.Systray(padding=3),
        widget.Spacer(length=8),
    ]
    return systray


def init_bright():
    if computer_type == 0:
        bright = [
            widget.Backlight(
                backlight_name="intel_backlight",
                foreground=colors[6],
                fmt="   BRT: {}",
                decorations=[
                    BorderDecoration(
                        colour=colors[6],
                        border_width=[0, 0, 2, 0],
                    )
                ],
            ),
            widget.Spacer(length=8),
        ]
    else:
        bright = []
    return bright


def init_battery():
    if computer_type == 0:
        battery = [
            widget.Battery(
                format="  BAT: {percent:2.0%}",
                foreground=colors[5],
                decorations=[
                    BorderDecoration(
                        colour=colors[5],
                        border_width=[0, 0, 2, 0],
                    )
                ],
            ),
            widget.Spacer(length=8),
        ]
    else:
        battery = []
    return battery


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    systray = init_systray()
    battery = init_battery()
    bright = init_bright()

    widgets_screen1 = widgets_screen1 + bright
    widgets_screen1 = widgets_screen1 + battery
    widgets_screen1 = widgets_screen1 + systray
    # widgets_screen1.append(systray)
    return widgets_screen1


# All other monitors' bars will display everything but widgets 22 (systray) and 23 (spacer).
def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    battery = init_battery()
    widgets_screen2 = widgets_screen2 + battery
    # del widgets_screen2[23:25]  # there is currently 26 widgets
    return widgets_screen2


# For adding transparency to your bar, add (background="#00000000") to the "Screen" line(s)
# For ex: Screen(top=bar.Bar(widgets=init_widgets_screen2(), background="#00000000", size=24)),


def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26)),
        Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26)),
        Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26)),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="dialog"),  # dialog boxes
        Match(wm_class="download"),  # downloads
        Match(wm_class="error"),  # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        # Match(wm_class="kdenlive"),  # kdenlive
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="notification"),  # notifications
        Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="toolbar"),  # toolbars
        Match(wm_class="Yad"),  # yad boxes
        Match(title="branchdialog"),  # gitk
        Match(title="Confirmation"),  # tastyworks exit box
        Match(title="Qalculate!"),  # qalculate-gtk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="tastycharts"),  # tastytrade pop-out charts
        Match(title="tastytrade"),  # tastytrade pop-out side gutter
        Match(title="tastytrade - Portfolio Report"),  # tastytrade pop-out allocation
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"),  # tastytrade settings
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/scripts/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
