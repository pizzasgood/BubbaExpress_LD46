extends Sprite

export var damage := 20
export var speed : float = 800
var ready_to_fire := true

onready var projectile = load("res://LaserBolt.tscn")
onready var emission_point = find_node("EmissionPoint")
onready var emission_point_base_pos = emission_point.position

func _ready():
	pass

func _process(delta):
	if flip_h:
		emission_point.position.x = -emission_point_base_pos.x
	else:
		emission_point.position.x = emission_point_base_pos.x
	if flip_v:
		emission_point.position.y = -emission_point_base_pos.y
	else:
		emission_point.position.y = emission_point_base_pos.y

func fire():
	if ready_to_fire:
		var p = projectile.instance()
		p.friendly = find_owner().friendly
		p.global_transform = emission_point.global_transform
		var direction = Vector2.RIGHT.rotated(emission_point.global_rotation)
		p.velocity = speed * direction
		p.damage = damage
		get_tree().get_current_scene().find_node("Level").add_child(p)
		ready_to_fire = false
		$CooldownTimer.start()
		$ShootSound.play()

func dumb_fire():
	ready_to_fire = false
	$CooldownTimer.start()

func find_owner(node = get_parent()):
	if "hp" in node:
		return node
	elif node.get_parent() != null:
		return find_owner(node.get_parent())
	else:
		return null

func _on_CooldownTimer_timeout():
	ready_to_fire = true
