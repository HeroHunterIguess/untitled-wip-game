extends Node

### data for the ui ###
var dash_timer = 0.0
var double_jumps = 0
var slam_timer = 0.0
var burst_timer = 0.0

var player_health = 100

### player related things ###
var max_jumps = 0 # 0 = only jumping on ground
var slamming = false
var can_freeze = false
var has_dash = false

var score = 0

var time_paused = 0.0

### ability slots ###
var melee_slot = "Basic melee"
# basic, ...
var range_slot = "" # laser is not yet implimented
# ...
var burst_slot = ""
# slam, burst, ...
