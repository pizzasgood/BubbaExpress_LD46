extends Area2D

var initial_damage = 10
var ongoing_damage = 50

onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(object):
	if object.is_in_group("player"):
		object.hp -= initial_damage

func _process(delta):
	if overlaps_body(player):
		player.hp -= ongoing_damage * delta
