extends KinematicBody2D

class_name Bot

var max_hp := 100
var hp : int = max_hp setget hp_set
var friendly := false

onready var sprite = find_node("BodySprite")
onready var drop = load("res://Scrap.tscn")

var weapons = []

func _ready():
	add_to_group("enemies")

func _on_DamageFlash_timeout():
	sprite.modulate = Color(1, 1, 1, 1)

func hp_set(new_hp):
	if new_hp > hp:
		sprite.modulate = Color(0, 1, 0.25, 1)
	else:
		sprite.modulate = Color(1, 0, 0, 1)
		var amount = hp - new_hp
		if randf() < (float(amount) / float(hp)):
			explode_weapon()
	$OwSound.play()
	$DamageFlash.start()
	hp = int(min(new_hp, max_hp))
	if hp <= 0:
		call_deferred("die")

func register_weapon(weapon):
	weapons.append(weapon)

func unregister_weapon(weapon):
	weapons.erase(weapon)

func explode_weapon():
	var num_weapons = len(weapons)
	if num_weapons > 0:
		weapons[randi() % num_weapons].die()

func die():
	$DeadSound.play()
	for w in weapons:
		w.active = false
	generate_drops()
	queue_free()

func generate_drops():
	var d = drop.instance()
	d.global_position = global_position
	get_tree().get_current_scene().find_node("Level").add_child(d)
	for w in weapons:
		w.generate_drops()
