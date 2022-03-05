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
STI = require 'lib/sti'

-- Hump.timer library for timer and tweening
-- may require local timers for different objects. For now its here, and global
-- Research other Hump libraries.
--
-- https://github.com/vrld/hump/blob/master/timer.lua
Timer = require 'lib/hump.timer'

-- StateMachine from GD50 Source Materials
require 'lib/StateMachine'

-- Game Features
require 'src/HUD'
Map = require 'src/Map'
HeroCam = require 'src/Camera'
require 'src/Animation'

-- Hero and Logic
require 'src/Hero/Hero'
require 'src/Hero/HeroDebug'
require 'src/Hero/NewHeroPhysics'
require 'src/Hero/NewHeroController'

-- Hero States
require 'src/Hero/states/BaseState'
require 'src/Hero/states/IdleState'
require 'src/Hero/states/JumpState'
require 'src/Hero/states/RunState'
require 'src/Hero/states/SkidState' -- Needs implementation
require 'src/Hero/states/SprintState'
require 'src/Hero/states/WalkState'
require 'src/Hero/states/FallState' -- Needs implementation

-- Entites
require 'src/Entities/Coin'
require 'src/Entities/Spike'
require 'src/Entities/Stone'
require 'src/Entities/Enemy'
require 'src/Entities/End'
