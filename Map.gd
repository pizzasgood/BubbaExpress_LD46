extends Node2D

var block_width = 1024
var block_height = 512

var terrain_names = [
	"Flat",
	"SmallDip",
	"SmallMound",
	"Rough",
	"ExtraRough",
	"AcidPools",
	"BigAcidPool",
]

var terrains = []

var map_data = [ 0, 0, 5, 1, 0, 2, 3, 1, 2, 5, 3, 4, 6, 1, 4, 0, 5 ]

func _ready():
	for name in terrain_names:
		terrains.append(load("res://terrain/%s.tscn" % name))

	var offset = 0
	for i in map_data:
		var t = terrains[i].instance()
		t.position = Vector2(offset, block_height)
		offset += block_width
		add_child(t)
