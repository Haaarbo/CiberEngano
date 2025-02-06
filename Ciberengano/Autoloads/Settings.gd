extends Node

var _config := ConfigFile.new()
var _config_path := "user://settings.cfg"

var master_bus := AudioServer.get_bus_index("Master")
var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

var master_volume: float = -30
var music_volume: float = 0
var sfx_volume: float = 0

func _ready() -> void:
	var err := _config.load(_config_path)

	if err == OK:
		load_settings()

func load_settings() -> void:
	master_volume = _config.get_value("Audio", "master_volume", master_volume)
	music_volume = _config.get_value("Audio", "music_volume", music_volume)
	sfx_volume = _config.get_value("Audio", "sfx_volume", sfx_volume)
	AudioServer.set_bus_volume_db(master_bus, master_volume)
	AudioServer.set_bus_volume_db(music_bus, music_volume)
	AudioServer.set_bus_volume_db(sfx_bus, sfx_volume)


func save_settings() -> void:
	_config.set_value("Audio", "master_volume", master_volume)
	_config.set_value("Audio", "music_volume", music_volume)
	_config.set_value("Audio", "sfx_volume", sfx_volume)
	_config.save(_config_path)

