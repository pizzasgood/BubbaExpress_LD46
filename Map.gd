tool
extends Node2D

var block_width = 1024
var block_height = 512

var bot_names = [
	"BOTGnat",
	"BOTSkeeter",
	"BOTDoubleRotor",
	"BOTBertha",
]

var terrain_names = [
	"Flat",
	"SmallDip",
	"SmallMound",
	"Rough",
	"ExtraRough",
	"AcidPools",
	"BigAcidPool",
	"City",
]

var bots = []
var terrains = []

export var map_seed : int = 2543624
export var num_bots := 30
export var bot_min_x : int = 3000
export var bot_min_y := -50
export var bot_max_y := 300

var left_data = [ 5, 6 ]
var map_data = [ 0, 0, 5, 1, 0, 2, 3, 1, 2, 5, 3, 4, 6, 1, 4, 7, 6, 6 ]

func _ready():
	for name in bot_names:
		bots.append(load("res://%s.tscn" % name))
	for name in terrain_names:
		terrains.append(load("res://terrain/%s.tscn" % name))

	var offset

	offset = block_width
	for i in left_data:
		var t = terrains[i].instance()
		t.position = Vector2(-offset, block_height)
		offset += block_width
		add_child(t)

	offset = 0
	for i in map_data:
		var t = terrains[i].instance()
		t.position = Vector2(offset, block_height)
		offset += block_width
		add_child(t)

	spawn_bots()

func spawn_bots():
	rand_seed(map_seed)
	var bot_max_x = (len(map_data) - 4) * block_width
	for i in range(num_bots):
		var x = int(rand_range(bot_min_x, bot_max_x))
		var y = int(rand_range(bot_min_y, bot_max_y))
		var b = randi() % len(bots)
		var bot = bots[b].instance()
		bot.position = Vector2(x, y)
		add_child(bot)

func get_progress(pos):
	# Victory happens when we're centered over the 3rd to last segment
	return pos / ((len(map_data) - 3) * block_width)

