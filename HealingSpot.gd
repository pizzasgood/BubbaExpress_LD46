extends Area2D

export var healing_rate : float = 10.0
export var friendly := true
var targets = []

func _ready():
	$Particles.emitting = false

func _process(delta):
	$Particles.emitting = false
	for t in targets:
		if "hp" in t:
			t.hp += healing_rate * delta
			$Particles.emitting = true


func _on_Healing_body_entered(body):
	if "friendly" in body and body.friendly == friendly:
		targets.append(body)

func _on_Healing_body_exited(body):
	targets.erase(body)
