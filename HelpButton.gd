extends TextureButton

onready var help_screen = get_tree().get_current_scene().find_node("Help")

func _ready():
	update()

func _pressed():
	help_screen.activate()
