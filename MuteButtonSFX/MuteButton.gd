extends TextureButton

export var texture_muted : Texture
export var texture_unmuted : Texture

func _ready():
	update()

func _pressed():
	Globals.mute_sfx = not Globals.mute_sfx
	update()

func update():
	if Globals.mute_sfx:
		texture_normal = texture_muted
	else:
		texture_normal = texture_unmuted
