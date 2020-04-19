extends Area2D

var mounted_item = null

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.has_method("set_drop_zone"):
		body.set_drop_zone(true, self)
		$Sprite.modulate = Color(1.25, 1.25, 1.25, 1)

func _on_body_exited(body):
	if body.has_method("set_drop_zone"):
		body.set_drop_zone(false, self)
		$Sprite.modulate = Color(1, 1, 1, 1)

func accepts_item(item) -> bool:
	return "upgrade" in item and mounted_item == null

func deploy(item):
	mounted_item = item.upgrade.instance()
	add_child(mounted_item)
	mounted_item.global_position = global_position
	$SoundEffect.play()
	item.queue_free()
