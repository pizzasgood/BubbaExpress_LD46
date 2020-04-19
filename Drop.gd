extends RigidBody2D

class_name Drop

var _collision_layer_backup
var _collision_mask_backup

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.has_method("pick_up"):
		body.call_deferred("pick_up", self)

func grabbed():
	mode = RigidBody2D.MODE_KINEMATIC
	_collision_layer_backup = collision_layer
	_collision_mask_backup = collision_mask
	collision_layer = 0
	collision_mask = 0

func thrown():
	mode = RigidBody2D.MODE_RIGID
	collision_layer = _collision_layer_backup
	collision_mask = _collision_mask_backup
