extends Node2D

export var damage : float = 20.0
export var max_range : float = 700
onready var max_range_squared : float = pow(max_range, 2)
export var speed : float = 500
var ready_to_fire := true
export var holding_fire := false
export var active := true
export var friendly := false


var target : Node2D = null
var target_in_range := false

onready var projectile = preload("res://LaserBolt.tscn")

func _ready():
	pass

func _process(delta):
	if active:
		acquire_target()

	if target != null:
		look_at(target.position)

	if target_in_range and ready_to_fire:
		fire()

func acquire_target():
	target = null
	target_in_range = false
	var best_distance = max_range_squared * 2
	var potentials = get_tree().get_nodes_in_group("friends")
	for i in potentials:
		var d = position.distance_squared_to(i.position)
		if d < best_distance:
			target = i
			best_distance = d
	if best_distance < max_range_squared:
		target_in_range = true

func fire():
	var p = projectile.instance()
	p.transform = transform
	p.direction = (target.position - position).normalized()
	p.speed = speed
	p.damage = damage
	get_tree().get_current_scene().find_node("Level").add_child(p)
	ready_to_fire = false
	$CooldownTimer.start()

func _on_CooldownTimer_timeout():
	ready_to_fire = true
