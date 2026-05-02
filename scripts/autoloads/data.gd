extends Node

# player related data stored here to be displayed the ui
var dash_timer = 0.0
var double_jumps = 2
var slam_timer = 0.0
var burst_timer = 0.0
var can_freeze = true
var slamming = false

var player_health = 100


# what does the player have unlocked
var has_dash = true
var has_ground_slam = true
var has_burst = true
var max_jumps = 2


var score = 0
