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
require 'src/Hero/Hero'

-- utility functions, mainly for splitting our sprite sheet into various Quads
-- of differing sizes for paddles, balls, bricks, etc.
require 'src/Util'

-- Hump.timer library for timer and tweening
-- may require local timers for different objects. For now its here, and global
-- Research other Hump libraries.
--
-- https://github.com/vrld/hump/blob/master/timer.lua
Timer = require 'lib/hump.timer'

require 'src/Animation'

-- StateMachine from GD50 Source Materials
require 'lib/StateMachine'

require 'src/Hero/states/BaseState'
require 'src/Hero/states/IdleState'
require 'src/Hero/states/JumpState'
require 'src/Hero/states/RunState'
require 'src/Hero/states/SkidState'
require 'src/Hero/states/SprintState'
require 'src/Hero/states/WalkState'
