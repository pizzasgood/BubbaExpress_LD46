extends KinematicBody2D

var walk_height = 150
var stand_speed = 100
var walk_speed = 100

var max_hp = 10000
var hp : int = max_hp setget hp_set
onready var hp_bar : ProgressBar = get_tree().get_current_scene().find_node("BubbaBar")
var friendly := true

enum { BURROWED, WAKING, RISING, STANDING, WALKING }
var state = BURROWED

func _ready():
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	wake()


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

func hp_set(new_hp):
	hp = min(new_hp, max_hp)
	hp_bar.value = hp
	if hp <= 0:
		call_deferred("die")

func die():
	get_tree().get_current_scene().find_node("GameOver").activate()
