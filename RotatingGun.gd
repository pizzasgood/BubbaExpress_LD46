extends Node2D

export var damage : float = 20.0
export var max_range : float = 700
onready var max_range_squared : float = pow(max_range, 2)
export var speed : float = 800
var ready_to_fire := true
export var holding_fire := false
export var active := true


var target : Node2D = null

onready var projectile = load("res://LaserBolt.tscn")
onready var drop = load("res://LaserTurret.tscn")

func _ready():
	register_with_owner()

func _process(delta):
	if active:
		acquire_target()
		if target != null:
			look_at(target.global_position)
			if in_range(target) and ready_to_fire:
				fire()

func acquire_target():
	target = null
	var max_threat = -1
	var potentials
	if find_owner().friendly:
		potentials = get_tree().get_nodes_in_group("enemies")
	else:
		potentials = get_tree().get_nodes_in_group("friends")
	for i in potentials:
		var threat = compute_threat(i)
		if threat > max_threat:
			target = i
			max_threat = threat

func in_range(enemy):
	return global_position.distance_squared_to(enemy.global_position) <= max_range_squared

func compute_threat(enemy):
	if not in_range(enemy):
		return 0
	var dps = 0
	if "weapons" in enemy:
		for w in enemy.weapons:
			dps += w.damage / w.find_node("CooldownTimer").wait_time
	return dps / enemy.hp

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
