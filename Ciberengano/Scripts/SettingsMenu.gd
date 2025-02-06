extends CanvasLayer

var _master_bus := Settings.master_bus
var _music_bus := Settings.music_bus
var _sfx_bus := Settings.sfx_bus

var _is_master_muted := false
var _is_music_muted := false
var _is_sfx_muted := false

onready var transition = get_node("Transition")
onready var animation_player = transition.get_node("AnimationPlayer")
onready var interface = get_node("Interface")
onready var master_volume = interface.get_node("MasterVolume")
onready var music_volume = interface.get_node("MusicVolume")
onready var sfx_volume = interface.get_node("SfxVolume")
func _ready() -> void:
	animation_player.play("FadeIn")
	yield(get_tree().create_timer(0.1), "timeout")
	interface.show()

	master_volume.value = Settings.master_volume
	music_volume.value = Settings.music_volume
	sfx_volume.value = Settings.sfx_volume
	

func _return_to_main_menu() -> void:
	transition.connect("animation_finished", self, "_on_animation_finished")
	animation_player.play("FadeOut")
	transition.play()


func _on_animation_finished() -> void:
	transition.disconnect("animation_finished", self, "_on_animation_finished")
	var menu_scene = load("res://Scenes/MainMenu.tscn")
	animation_player.stop(true)
	var _err = get_tree().change_scene_to(menu_scene)


func _on_SaveButton_pressed() -> void:
	Settings.save_settings()
	_return_to_main_menu()


func _transform_db_to_volume(value: float) -> int:
	var scaled_value = (value - -60) / 60
	return int(scaled_value * 100)


func _on_MasterVolume_value_changed(value: float) -> void:
	Settings.master_volume = value
	AudioServer.set_bus_volume_db(_master_bus, value)
	master_volume.get_node("Value").text = str(_transform_db_to_volume(value))

	if value != -60 and _is_master_muted:
		AudioServer.set_bus_mute(_master_bus, false)
		_is_master_muted = false
	elif value == -60 and not _is_master_muted:
		AudioServer.set_bus_mute(_master_bus, true)
		_is_master_muted = true


func _on_MusicVolume_value_changed(value: float) -> void:
	Settings.music_volume = value
	AudioServer.set_bus_volume_db(_music_bus, value)
	music_volume.get_node("Value").text = str(_transform_db_to_volume(value))

	if value != -60 and _is_music_muted:
		AudioServer.set_bus_mute(_music_bus, false)
		_is_music_muted = false
	elif value == -60 and not _is_music_muted:
		AudioServer.set_bus_mute(_music_bus, true)
		_is_music_muted = true


func _on_SfxVolume_value_changed(value: float) -> void:
	Settings.sfx_volume = value
	AudioServer.set_bus_volume_db(_sfx_bus, value)
	sfx_volume.get_node("Value").text = str(_transform_db_to_volume(value))

	if value != -60 and _is_sfx_muted:
		AudioServer.set_bus_mute(_sfx_bus, false)
		_is_sfx_muted = false
	elif value == -60 and not _is_sfx_muted:
		AudioServer.set_bus_mute(_sfx_bus, true)
		_is_sfx_muted = true
