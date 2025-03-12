import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Hooks.RefocusLast (refocusLastLogHook)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Define variables
myTerminal      = "xfce4-terminal --disable-server"
browser         = "firefox-esr"
home            = "your home directory"
wallpaper       = (home ++ "/linux_computer/background_photo/5825739.jpg")

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2

myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]

myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#00ffff"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [
    -- screenshot
      ((0,                          xK_Print),      spawn ("bash -c 'xfce4-screenshooter -crs Pictures/screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png'"))
    , ((modm,                       xK_Print),      spawn ("bash -c 'xfce4-screenshooter -cfs Pictures/screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png'"))

    -- monitor
    , ((0,                          0x1008ff59),    spawn (myTerminal++" -e "++home ++ "/.config/xmonad/monitor.sh"))

    -- play pause
    , ((mod1Mask,                   xK_space),      spawn ("playerctl play-pause || parole --play"))

    -- volume
    , ((0,                          0x1008ff11),    spawn (home ++ "/.config/xmonad/dunst/volume_decrease.sh"))
    , ((0,                          0x1008ff13),    spawn (home ++ "/.config/xmonad/dunst/volume_increase.sh"))
    , ((0,                          0x1008ff12),    spawn (home ++ "/.config/xmonad/dunst/volume_mute.sh"))

    -- mute mic
    , ((0,                          0x1008ffb2),    spawn (home ++ "/.config/xmonad/dunst/mic_mute.sh"))
    
    -- brightness
    , ((0,                          0x1008ff02),    spawn (home ++ "/.config/xmonad/dunst/brightness_increase.sh"))
    , ((0,                          0x1008ff03),    spawn (home ++ "/.config/xmonad/dunst/brightness_decrease.sh"))

    -- clipboard manager
    , ((modm,                       xK_v),          spawn "xfce4-popup-clipman")

    -- poweroff
    , ((controlMask .|. mod1Mask,   xK_Delete),     spawn "sudo poweroff")


    -- Launch programme

    -- launch a terminal
    , ((controlMask .|. mod1Mask,   xK_t),          spawn $ XMonad.terminal conf)

    -- launch app finder
    , ((modm,                       xK_p),          spawn "xfce4-appfinder")
    , ((modm,                       xK_slash),      spawn (myTerminal++" -T run_command --geometry 40x1 -e "++home++"/.config/xmonad/run_command.sh"))
    , ((modm .|. shiftMask,         0x1008ffb1),    spawn "xfce4-appfinder")

    -- launch firefox
    , ((controlMask .|. mod1Mask,   xK_f),          spawn (browser))
    , ((controlMask .|. mod1Mask,   xK_y),          spawn (browser ++ " --private-window 'youtube.com'"))

    -- launch file manager
    , ((controlMask .|. mod1Mask,   xK_h),          spawn "thunar")

    -- launch kde connect
    , ((controlMask .|. mod1Mask,   xK_k),          spawn "kdeconnect-app")

    -- launch virtual machine
    , ((controlMask .|. mod1Mask,   xK_g),          spawn "gnome-boxes")

    -- launch jupyter notebook
    , ((controlMask .|. mod1Mask,   xK_j),          spawn (home ++ "/linux_computer/jupyter_file/jupyter.sh"))

    -- launch pycharm
    , ((controlMask .|. mod1Mask,   xK_p),          spawn (home ++ "/.local/share/JetBrains/Toolbox/apps/pycharm-community/bin/pycharm.sh"))

    -- launch webstorm
    , ((controlMask .|. mod1Mask,   xK_w),          spawn (home ++ "/.local/share/JetBrains/Toolbox/apps/webstorm/bin/webstorm.sh"))

    -- close focused window
    , ((modm,                       xK_w),          kill)

     -- Rotate through the available layout algorithms
    , ((modm,                       xK_Tab),        sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm,                       xK_n),          setLayout $ XMonad.layoutHook conf)

    -- Move focus to the next window
    , ((modm,                       xK_j),          windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,                       xK_k),          windows W.focusUp  )

    -- Swap the focused window and the master window
    , ((modm,                       xK_m),          windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask,         xK_j),          windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask,         xK_k),          windows W.swapUp    )

    -- Shrink the master area
    , ((modm,                       xK_h),          sendMessage Shrink)

    -- Expand the master area
    , ((modm,                       xK_l),          sendMessage Expand)

    -- Push window back into tiling
    , ((modm,                       xK_t),          withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm,                       xK_comma),      sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,                       xK_period),     sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    , ((modm,                       xK_f),          sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask,         xK_q),          io (exitWith ExitSuccess))

    -- Lock screen
    , ((modm .|. shiftMask,         xK_w),          spawn "dm-tool lock")

    -- Restart xmonad
    , ((modm .|. shiftMask,         xK_r),          spawn "kill $(pgrep polybar); xmonad --recompile; xmonad --restart")


    -- Scratchpads
    , ((modm,                       xK_semicolon),  namedScratchpadAction scratchpads "spthunar")
    , ((controlMask .|. mod1Mask,   xK_c),          namedScratchpadAction scratchpads "spcalc")
    , ((controlMask .|. mod1Mask,   xK_v),          namedScratchpadAction scratchpads "spvpn")
    , ((0,                          0x1008ff30),    namedScratchpadAction scratchpads "spcalc")
    , ((modm,                       xK_Return),     namedScratchpadAction scratchpads "spterm")


    -- shift to workspace
    , ((modm .|. shiftMask,         xK_1),          windows (W.greedyView "1" . W.shift "1"))
    , ((modm .|. shiftMask,         xK_2),          windows (W.greedyView "2" . W.shift "2"))
    , ((modm .|. shiftMask,         xK_3),          windows (W.greedyView "3" . W.shift "3"))
    , ((modm .|. shiftMask,         xK_4),          windows (W.greedyView "4" . W.shift "4"))
    , ((modm .|. shiftMask,         xK_5),          windows (W.greedyView "5" . W.shift "5"))
    , ((modm .|. shiftMask,         xK_6),          windows (W.greedyView "6" . W.shift "6"))
    , ((modm .|. shiftMask,         xK_7),          windows (W.greedyView "7" . W.shift "7"))
    , ((modm .|. shiftMask,         xK_8),          windows (W.greedyView "8" . W.shift "8"))
    , ((modm .|. shiftMask,         xK_9),          windows (W.greedyView "9" . W.shift "9"))
    , ((modm .|. shiftMask,         xK_0),          windows (W.greedyView "10" . W.shift "10"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]
        , (f, m) <- [(W.greedyView, 0), (W.shift, controlMask)]]
    -- ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts
--
myLayout = avoidStruts (smartBorders tiled ||| noBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules
--
myManageHook = composeAll
    [ title     =? "run_command"        --> doFloat
    -- , className =? "Xfce4-appfinder"    --> doFloat
    , resource  =? "desktop_window"     --> doIgnore
    , resource  =? "kdesktop"           --> doIgnore ] <+> namedScratchpadManageHook scratchpads

------------------------------------------------------------------------
-- Event handling
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging
--
myLogHook = do
    refocusLastLogHook
        >> nsHideOnFocusLoss scratchpads

------------------------------------------------------------------------
-- Startup hook
--
myStartupHook = do
    spawnOnce ("feh --bg-fill " ++ wallpaper)
    spawnOnce (home ++ "/.config/xmonad/autostart.sh")
    windows (W.greedyView "10")

------------------------------------------------------------------------
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    xmproc <- spawnPipe "polybar &"
    xmonad $ docks . ewmh $ defaults

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

scratchpads = [
    NS "spvifm" (myTerminal++" -T spvifm -e vifm") (title =? "spvifm")
    (customFloating $ W.RationalRect (0.05) (0.05) (0.9) (0.9)),
    NS "spthunar" "thunar" (className =? "Thunar")
    (customFloating $ W.RationalRect (0.15) (0.2) (0.7) (0.5)),
    NS "spcalc" (myTerminal++" -T spcalc -e 'python3 -i "++home++"/linux_computer/jupyter_file/import.py'") (title =? "spcalc")
    (customFloating $ W.RationalRect (0.3) (0.03) (0.4) (0.4)),
    NS "spvpn" (myTerminal++" -T spvpn -e 'bash "++home++"/linux_computer/linux_setup/vpn/connect.sh'") (title =? "spvpn")
    (customFloating $ W.RationalRect (0.27) (0.27) (0.46) (0.46)),
    NS "spterm" (myTerminal++" -T spterm") (title =? "spterm")
    (customFloating $ W.RationalRect (0.27) (0.27) (0.46) (0.46))
    ] where role = stringProperty "WM_WINDOW_ROLE"

