extends KinematicBody2D

class_name Bot

export var max_hp := 100
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
		var chance = 1 if hp <= 0 else float(hp - new_hp) / float(hp)
		if randf() < chance:
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
	collision_layer = 0
	collision_mask = 0
	$DeadSound.play()
	$BodySprite.visible =  false
	$ExplosionEffect.emitting = true
	for w in weapons:
		w.active = false
	generate_drops()
	$DeathTimer.start()

func generate_drops():
	var d = drop.instance()
	d.global_position = global_position
	get_tree().get_current_scene().find_node("Level").add_child(d)
	for w in weapons:
		w.generate_drops()


func _on_DeathTimer_timeout():
	queue_free()
