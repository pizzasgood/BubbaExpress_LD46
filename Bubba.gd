extends KinematicBody2D

var walk_height = 150
var stand_speed = 100
var walk_speed = 100

var max_hp := 10000
var hp : int = 0.5 * max_hp setget hp_set
onready var hp_bar : ProgressBar = get_tree().get_current_scene().find_node("BubbaBar")
var friendly := true

var weapons = []

onready var map = get_tree().get_current_scene().find_node("Map")

enum { BURROWED, WAKING, RISING, STANDING, WALKING }
var state = BURROWED

func _ready():
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	wake()

func _process(delta):
	var progress = map.get_progress(position.x)
	if progress > 1:
		call_deferred("win")

func _physics_process(delta):
	match state:
		WAKING:
			#TODO: shake
			pass
		RISING:
			if position.y > walk_height:
				position.y -= stand_speed * delta
			else:
				get_ready()
		STANDING:
			#TODO: rumble
			pass
		WALKING:
			position.x += walk_speed * delta

func wake():
	state = WAKING
	$WakeTimer.start()
	$StartupRumble.play()

func get_up():
	state = RISING

func get_ready():
	state = STANDING
	$ReadyTimer.start()
	$StartupRumble.stop()
	$EngineSound.play()

func get_moving():
	state = WALKING
	Globals.get_bgm().play()


func _on_WakeTimer_timeout():
	get_up()

func _on_ReadyTimer_timeout():
	get_moving()

func hp_set(new_hp : int):
	if new_hp > hp:
		pass
	else:
		$OwSound.play()
		var chance = 1 if hp <= 0 else float(hp - new_hp) / float(hp)
		if randf() < chance:
			explode_weapon()
	hp = int(min(new_hp, max_hp))
	hp_bar.value = hp
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
	get_tree().get_current_scene().find_node("GameOver").activate()

func win():
	get_tree().get_current_scene().find_node("Victory").activate()


func _on_Healing_body_entered(body):
	pass # Replace with function body.


func _on_Healing_body_exited(body):
	pass # Replace with function body.
