-- ~/.config/awesome/rc.lua
-- vim:ft=lua:

-- Awesome standard library.
require("awful")
require("awful.autofocus")
require("awful.rules")

-- Themes.
require("beautiful")

-- Notifications.
require("naughty")

-- Widgets.
require("obvious")

-- Mac OS X's Exposé.
require("revelation")

-- Load my theme.
beautiful.init(awful.util.getdir("config") .. "/theme.lua")

-- Helper function to find applications on your PATH using which.
-- apps is a list of applications in order of decreasing preference.
function find_app(apps)
    -- Return the first application we find.
    for i = 1, #apps do
        if os.execute("which " .. apps[i]) == 0 then
            return apps[i]
        end
    end

    -- Return nil if nothing was found.
    return nil
end

-- Helper function to display a notification if a keybinding is called for
-- an application that we could not find.
function app_not_found(name)
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Keybinding failed",
        text = "Application class  \"" .. name .. "\" not found on path."
    })
end

-- Find applications that we will use for key bindings.
apps = {
    file_manager = find_app({ "thunar", "nautilus" }),
    screensaver = find_app({ "xscreensaver", "gnome-screensaver" }),
    screenshot = find_app({ "scrot" }),
    terminal = find_app({ "urxvtc", "x-terminal-emulator", "gnome-terminal" })
}

-- Modifier key used for Awesome commands.
modkey = "Mod4"

-- Window layouts, in order.
layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal
}

-- Define tags for each screen.
tags = {}

-- Assign a name and programs to tabs.
tags.info = {
    {
        title = "emacs",
        progs = { "Emacs" },
    },
    {
        title = "web",
        progs = { "Chromium", "Firefox", "Iceweasel" },
    },
    {
        title = "mail",
        progs = { "Icedove", "Thunderbird" },
    },
    {
        title = "doc",
        progs = { "Xpdf", "libreoffice-.*" },
    },
    {
        title = "IM",
        progs = { "Pidgin" },
    },
    {
        title = "media",
        progs = { "Audacious", "Gnome-mplayer" },
    },
    {
        title = nil,
        progs = {},
    },
    {
        title = nil,
        progs = {},
    },
}

-- Build the list of tag names.
tags.names = {}
for i = 1, #tags.info do
    -- If the tag has a title, concatenate it with the index.
    if tags.info[i].title ~= nil then
        tags.names[i] = i .. "-" .. tags.info[i].title
    else
        tags.names[i] = i
    end
end

-- Create the tags. They are assigned to the primary screen.
tags[1] = awful.tag(tags.names, 1, layouts[1])

-- Create generic tags for the other screens.
for s = 2, screen.count() do
    tags[s] = awful.tag({1, 2, 3, 4}, s, layouts[1])
end

-- Create a main menu.
mymainmenu = { items = {} }

-- A seperator.
table.insert(mymainmenu.items, { "---", nil })
table.insert(mymainmenu.items, { "Restart", awesome.restart })
table.insert(mymainmenu.items, { "Quit", awesome.quit })

mymainmenu.menu = awful.menu({ items = mymainmenu.items })

-- Define mouse bindings for taglist widgets.
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    -- Clicking on a tag switches to it. (Exclusive.)
    awful.button({}, 1, awful.tag.viewonly),
    -- Right-clicking on a tag toggles visiblity. (Not exclusive.)
    awful.button({}, 3, awful.tag.viewtoggle)
)

-- Define mouse bindings for tasklist widgets.
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    -- Clicking on a task gives it focus.
    awful.button({}, 1, function (c)
        -- If the task is already focused, minimize it.
        if c == client.focus then
            c.minimized = true
        else
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            -- This will unminimize the task if necessary.
            client.focus = c
            c:raise()
        end
    end),

    -- Right-clicking on a task drops a menu of all tasks.
    awful.button({}, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width=250 })
        end
    end)
)

-- Create a clock widget.
myclock = obvious.clock()

-- TODO: Can I just remove the signal handler instead?
-- I don't care for the mouse-over action, so use ISO format for both.
datefmt = " %Y-%m-%d %H:%M "
obvious.clock.set_shortformat(datefmt)
obvious.clock.set_longformat(datefmt)

-- Create a systray widget.
mysystray = widget({ type = "systray" })

-- Create a battery widget.
mybattery = obvious.battery()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}

for s = 1, screen.count() do
    -- Create a promptbox for each screen.
    mypromptbox[s] = awful.widget.prompt({
        layout = awful.widget.layout.horizontal.leftright
    })

    -- Create a layoutbox widget.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
        -- Clicking switches to the next layout.
        awful.button({}, 1, function ()
            awful.layout.inc(layouts, 1)
        end),

        -- Right-clicking switches to the previous layout.
        awful.button({}, 3, function ()
            awful.layout.inc(layouts, -1)
        end)
    ))

    -- Create a taglist widget.
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all,
        mytaglist.buttons)

    -- Create a tasklist widget.
    mytasklist[s] = awful.widget.tasklist(
        function (c)
            return awful.widget.tasklist.label.currenttags(c, s)
        end,
        mytasklist.buttons
    )

    -- Create a wibox.
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Add the widgets to the wibox.
    mywibox[s].widgets = {
        -- These widgets are added from left to right.
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        -- These widgets are added from right to left.
        mylayoutbox[s],
        myclock,
        s == 1 and mysystray or nil, -- This widget can only exist once.
        mybattery,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end

-- Global key bindings. All keys use the modkey.
globalkeys = awful.util.table.join(
    -- Left, right switch tags.
    awful.key({ modkey }, "Left", awful.tag.viewprev),
    awful.key({ modkey }, "Right", awful.tag.viewnext),

    -- Tab switches to the previous tag(s).
    awful.key({ modkey }, "Tab", awful.tag.history.restore),

    -- w, W switches clients (transfers focus).
    awful.key({ modkey }, "w", function ()
        awful.client.focus.byidx(1)
        if client.focus then
            client.focus:raise()
        end
    end),
    awful.key({ modkey, "Shift" }, "w", function ()
        awful.client.focus.byidx(-1)
        if client.focus then
            client.focus:raise()
        end
    end),

    -- ^w, ^W switches screens.
    awful.key({ modkey, "Control" }, "w", function ()
        awful.screen.focus_relative(1)
    end),
    awful.key({ modkey, "Control", "Shift" }, "w", function ()
        awful.screen.focus_relative(-1)
    end),

    -- u focuses on the most recent urgent client.
    awful.key({ modkey }, "u", awful.client.urgent.jumpto),

    -- Ret spawns a terminal as defined above.
    awful.key({ modkey }, "Return", function ()
        if (apps.terminal == nil) then
            app_not_found("terminal")
        else
            awful.util.spawn(apps.terminal)
        end
    end),

    -- Shift+Ret spawns a file manager as defined above.
    awful.key({ modkey, "Shift" }, "Return", function ()
        if (apps.file_manager == nil) then
            app_not_found("file_manager")
        else
            awful.util.spawn(apps.file_manager)
        end
    end),

    -- Esc opens the menu.
    awful.key({ modkey }, "Escape", function ()
        mymainmenu.menu:toggle()
    end),

    -- ^e triggers exposé.
    awful.key({ modkey, "Control" }, "e", revelation),

    -- ^r restarts awesome.
    awful.key({ modkey, "Control" }, "r", awesome.restart),

    -- ^q quits awesome.
    awful.key({ modkey, "Control" }, "q", awesome.quit),

    -- ^l launches the screensaver as defined above.
    awful.key({ modkey, "Control" }, "l", function ()
        if (apps.screensaver == nil) then
            app_not_found("screensaver")
        elseif (apps.screensaver == "xscreensaver") then
            awful.util.spawn("xscreensaver-command -activate")
        elseif (apps.screensaver == "gnome-screensaver") then
            awful.util.spawn("gnome-screensaver-command -l")
        end
    end),

-- TODO: Do I want to keep these?
--    awful.key({ modkey, "Shift" }, "h", function ()
--        awful.tag.incnmaster(1)
--    end),
--
--    awful.key({ modkey, "Shift" }, "l", function ()
--        awful.tag.incnmaster(-1)
--    end),
--
--    awful.key({ modkey, "Control" }, "h", function ()
--        awful.tag.incncol(1)
--    end),
--
--    awful.key({ modkey, "Control" }, "l", function ()
--        awful.tag.incncol(-1)
--    end),

    -- Space, Shift+Space toggle through layouts.
    awful.key({ modkey }, "space", function ()
        awful.layout.inc(layouts, 1)
    end),
    awful.key({ modkey, "Shift" }, "space", function ()
        awful.layout.inc(layouts, -1)
    end),

    -- H un-minimizes. (h is a client key).
    awful.key({ modkey, "Shift" }, "h", awful.client.restore),

    -- r launches a program.
    awful.key({ modkey }, "r", function ()
        mypromptbox[mouse.screen]:run()
    end),

    awful.key({}, "Print", function ()
        if (apps.screenshot == nil) then
            app_not_found("screenshot")
        else
            awful.util.spawn(apps.screenshot)
        end
    end),

    awful.key({}, "XF86AudioPlay", function ()
        awful.util.spawn("audtool --playback-playpause")
    end),

    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.util.spawn("amixer set Master playback 2+")
    end),

    awful.key({}, "XF86AudioLowerVolume", function ()
        awful.util.spawn("amixer set Master playback 2-")
    end),

    awful.key({}, "XF86AudioMute", function ()
        awful.util.spawn("amixer set Master toggle")
    end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        -- # views that tag exclusively.
        awful.key({ modkey }, "#" .. i + 9, function ()
            if tags[1][i] then
                awful.tag.viewonly(tags[1][i])
            end
        end),

        -- ^# toggles visibility of that tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
            if tags[1][i] then
                awful.tag.viewtoggle(tags[1][i])
            end
        end),

        -- Shift+# moves the client to that tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end)
    )
end

-- Set global keys.
root.keys(globalkeys)

-- Client (i.e. window) key bindings.
clientkeys = awful.util.table.join(
    -- q quits a client.
    awful.key({ modkey }, "q", function (c)
        c:kill()
    end),

    -- TODO: This doesn't always work for some reason.
    -- m toggles fullscreen (maximize).
    awful.key({ modkey }, "m", function (c)
        c.fullscreen = not c.fullscreen
    end),

    -- h minimizes the client (hide).
    awful.key({ modkey }, "h", function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end),

    -- f toggles floating.
    awful.key({ modkey }, "f", awful.client.floating.toggle),

    -- t toggles "on-top-ness".
    awful.key({ modkey }, "t", function (c)
        c.ontop = not c.ontop
    end),

    -- r redraws the client.
    awful.key({ modkey, "Shift" }, "r", function (c)
        c:redraw()
    end),

    -- o moves the client to the next screen. (TODO: change binding?)
    awful.key({ modkey }, "o", awful.client.movetoscreen)
)

-- Client (i.e. window) mouse bindings.
clientbuttons = awful.util.table.join(
    -- Clicking on a client transfers focus.
    awful.button({}, 1, function (c)
        client.focus = c
        c:raise()
    end),

    -- Modkey + click moves floating windows.
    awful.button({ modkey }, 1, awful.mouse.client.move),

    -- Modkey + right-click resizes floating windows.
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Define client rules.
clientrules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = true,
            keys = clientkeys,
            buttons = clientbuttons
        }
    },

    -- Don't tile VirtualBox. Ideally, I could still tile the configuration
    -- window, but I do not know how to distinguish between that window and
    -- virtual machine display windows.
    {
        rule = { class = "VirtualBox" },
        properties = { floating = true }
    }
}

-- Generate rules to pin programs to tags as defined previously.
for i = 1, #tags.info do
    for j = 1, #tags.info[i].progs do
        table.insert(clientrules, {
            rule = { class = tags.info[i].progs[j] },
            properties = { tag = tags[1][i] }
        })
    end
end

-- Set the client rules.
awful.rules.rules = clientrules

-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- TODO: I'm not sure what this really does.
    if not startup then
        -- Set placement hints if the client does not have a position.
        if not c.size_hints.user_position and
                not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

-- Add focus-sensitive borders.
client.add_signal("focus", function (c)
    c.border_color = beautiful.border_focus
end)
client.add_signal("unfocus", function (c)
    c.border_color = beautiful.border_normal
end)
