extends CenterContainer

onready var resume_button : Button = find_node("ResumeButton")

func _on_ResumeButton_pressed():
	visible = false
	get_tree().paused = false

func _ready():
	visible = false
	resume_button.connect("pressed", self, "_on_ResumeButton_pressed")

func _unhandled_input(event):
	if event.is_action_pressed("help"):
		if visible:
			_on_ResumeButton_pressed()
		else:
			activate()
		get_tree().set_input_as_handled()

func activate():
	visible = true
	resume_button.grab_focus()
	get_tree().paused = true
