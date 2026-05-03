extends Node

### data for the ui ###
var dash_timer = 0.0
var double_jumps = 2
var slam_timer = 0.0
var burst_timer = 0.0

var player_health = 100


### player related things ###
var has_dash = true
var has_ground_slam = true
var has_burst = true
var max_jumps = 2

var score = 0

var slamming = false
var can_freeze = true


### ability slots ###
var melee_slot = "basic"
# basic, ...
var range_slot = "laser" # laser is not yet implimented
# ...
var burst_slot = "slam"
# slam, burst, ...
