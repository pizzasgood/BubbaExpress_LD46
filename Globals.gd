extends Node

var mute_bgm := false setget mute_bgm_set, mute_bgm_get
var mute_sfx := false setget mute_sfx_set, mute_sfx_get

func mute_bgm_set(new_value):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), new_value)

func mute_bgm_get():
	return AudioServer.is_bus_mute(AudioServer.get_bus_index("BGM"))

func mute_sfx_set(new_value):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), new_value)

func mute_sfx_get():
	return AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))

func get_bgm():
	return get_tree().get_current_scene().find_node("BGM")
