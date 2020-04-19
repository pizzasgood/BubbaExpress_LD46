extends RigidBody2D

class_name Drop

var _collision_layer_backup
var _collision_mask_backup

var claimed = false

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if not claimed and body.has_method("pick_up"):
		claimed = true
		body.call_deferred("pick_up", self)

func grabbed():
	mode = RigidBody2D.MODE_KINEMATIC
	disable_collision()

func thrown():
	claimed = false
	mode = RigidBody2D.MODE_RIGID
	enable_collision()

func disable_collision():
	_collision_layer_backup = collision_layer
	_collision_mask_backup = collision_mask
	collision_layer = 0
	collision_mask = 0

func enable_collision():
	collision_layer = _collision_layer_backup
	collision_mask = _collision_mask_backup
