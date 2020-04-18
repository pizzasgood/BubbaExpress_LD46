extends CenterContainer

onready var retry_button : Button = find_node("RetryButton")
onready var quit_button : Button = find_node("QuitButton")

func _on_RetryButton_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene("res://Main.tscn")

func _on_QuitButton_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene("res://TitleScreen.tscn")

func _ready():
	visible = false
	retry_button.connect("pressed", self, "_on_RetryButton_pressed")
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")

func activate():
	visible = true
	retry_button.grab_focus()
	get_tree().paused = true
