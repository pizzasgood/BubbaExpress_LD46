extends KinematicBody2D

var walk_height = 150
var stand_speed = 100
var walk_speed = 100

var hp = 10000

enum { BURROWED, WAKING, RISING, STANDING, WALKING }
var state = BURROWED

func _ready():
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
