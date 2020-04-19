extends Node2D

export var damage : float = 20.0
export var max_range : float = 700
onready var max_range_squared : float = pow(max_range, 2)
export var speed : float = 800
var ready_to_fire := true
export var holding_fire := false
export var active := true


var target : Node2D = null
var target_in_range := false

onready var projectile = load("res://LaserBolt.tscn")
onready var drop = load("res://LaserTurret.tscn")

func _ready():
	register_with_owner()

func _process(delta):
	if active:
		acquire_target()

		if target != null:
			look_at(target.global_position)

		if target_in_range and ready_to_fire:
			fire()

func acquire_target():
	target = null
	target_in_range = false
	var best_distance = max_range_squared * 2
	var potentials
	if find_owner().friendly:
		potentials = get_tree().get_nodes_in_group("enemies")
	else:
		potentials = get_tree().get_nodes_in_group("friends")
	for i in potentials:
		var d = global_position.distance_squared_to(i.global_position)
		if d < best_distance:
			target = i
			best_distance = d
	if best_distance < max_range_squared:
		target_in_range = true

func fire():
	if ready_to_fire:
		var p = projectile.instance()
		p.friendly = find_owner().friendly
		p.global_transform = global_transform
		var direction = Vector2.RIGHT.rotated(global_rotation)
		p.velocity = speed * direction
		p.damage = damage
		get_tree().get_current_scene().find_node("Level").add_child(p)
		ready_to_fire = false
		$CooldownTimer.start()
		$ShootSound.play()

func find_owner(node = get_parent()):
	if "hp" in node:
		return node
	elif node.get_parent() != null:
		return find_owner(node.get_parent())
	else:
		return null

func _on_CooldownTimer_timeout():
	ready_to_fire = true

func register_with_owner():
	var owner = find_owner()
	if owner == null:
		return
	if owner.has_method("register_weapon"):
		owner.register_weapon(self)

func generate_drops():
	var d = drop.instance()
	d.global_position = global_position
	get_tree().get_current_scene().find_node("Level").add_child(d)
