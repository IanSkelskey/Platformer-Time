-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- a few global constants, centralized
require 'src/Hero'

-- utility functions, mainly for splitting our sprite sheet into various Quads
-- of differing sizes for paddles, balls, bricks, etc.
require 'src/Util'

-- Hump.timer library for timer and tweening
-- may require local timers for different objects. For now its here, and global
-- Research other Hump libraries.
--
-- https://github.com/vrld/hump/blob/master/timer.lua
Timer = require 'lib/hump.timer'

-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
-- require 'src/states/BaseState'
