extends Node

### data for the ui ###
var dash_timer = 0.0
var double_jumps = 2
var slam_timer = 0.0
var burst_timer = 0.0

var player_health = 100


### player related things ###
var max_jumps = 2
var slamming = false
var can_freeze = true
var has_dash = true

var score = 0


### ability slots ###
var melee_slot = "basic"
# basic, ...
var range_slot = "laser" # laser is not yet implimented
# ...
var burst_slot = "slam"
# slam, burst, ...
