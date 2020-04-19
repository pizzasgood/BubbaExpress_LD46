extends Area2D

var velocity : Vector2
var ignore : Node2D
var damage : float = 20.0

func _ready():
	pass

func _physics_process(delta):
	position += delta * velocity


func _on_LaserBolt_body_entered(body):
	if "hp" in body and body != ignore:
		body.hp -= damage
		queue_free()
