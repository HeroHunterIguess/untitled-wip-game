extends Node

### data for the ui ###
var dash_timer = 0.0
var double_jumps = 0.0
var melee_timer = 0.0
var burst_timer = 0.0
var ranged_timer = 0.0 # ranged not currently implemented

var player_health = 100
var max_health = 100

### player related things ###
var max_jumps = 0 # 0 = only jumping on ground
var slamming = false

var can_freeze = false
var has_freeze = false

var has_dash = false
var dashing = false

var score = 0

var time_paused = 0.0

### ability slots ###
var melee_slot = "Basic melee"
# basic, ...
var range_slot = ""
# ...
var burst_slot = ""
# slam, burst, ...

### ability tiers ###
var current_melee_tier = 0
var current_burst_tier = -1 # -1 means start with nothing
var current_ranged_tier = -1 # -1 means start with nothing
var current_movement_upgrade = -1 # -1 means start with nothing

### ability damage bonuses ###
var melee_damage_increase = 0
var ranged_damage_increase = 0
var burst_damage_increase = 0
