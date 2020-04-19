extends Area2D

var velocity : Vector2
var damage := 20
var friendly : bool setget friendly_set

func _ready():
	pass

func _physics_process(delta):
	position += delta * velocity

func _on_LaserBolt_body_entered(body):
	if "hp" in body and body.friendly != friendly:
		body.hp -= damage
		queue_free()

func friendly_set(value):
	friendly = value
	if friendly:
		$Sprite.modulate = Color(0, 1, 1, 1)
	else:
		$Sprite.modulate = Color(1, 0.25, 0, 1)
