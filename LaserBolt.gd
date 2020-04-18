extends Area2D

var speed : float
var direction : Vector2
var ignore : Node2D
var damage : float = 20.0

func _ready():
	pass

func _physics_process(delta):
	position += speed * delta * direction


func _on_LaserBolt_body_entered(body):
	if "hp" in body:
		body.hp -= damage
		queue_free()
