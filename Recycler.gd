extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.has_method("set_drop_zone"):
		body.set_drop_zone(true, self)

func _on_body_exited(body):
	if body.has_method("set_drop_zone"):
		body.set_drop_zone(false, self)

func accepts_item(item) -> bool:
	return "hp_provided" in item

func deploy(item):
	find_owner().hp += item.hp_provided
	$SoundEffect.play()
	item.queue_free()

func find_owner(node = get_parent()):
	if "hp" in node:
		return node
	elif node.get_parent() != null:
		return find_owner(node.get_parent())
	else:
		return null
