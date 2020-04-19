extends CenterContainer

onready var quit_button : Button = find_node("QuitButton")

func _on_QuitButton_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene("res://TitleScreen.tscn")

func _ready():
	visible = false
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")

func activate():
	visible = true
	quit_button.grab_focus()
	get_tree().paused = true
