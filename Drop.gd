extends RigidBody2D

class_name Drop

func _ready():
	pass

func _on_Area2D_body_entered(body):
	# This might not be perfect; what if you manage two simultaneous collisions?
	if body.has_method("pick_up") and body.has_method("can_pick_up") and body.can_pick_up():
		mode = RigidBody2D.MODE_KINEMATIC
		body.call_deferred("pick_up", self)

func thrown():
	mode = RigidBody2D.MODE_RIGID
