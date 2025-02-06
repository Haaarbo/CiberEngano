extends Node

var _save_path := "user://save.res"
var current_save := {
	"player_level": 1,
	"score": {
		"level_1": 0,
		"level_2": 0,
		"level_3": 0
	},
	"endless_score": 0
}
var selected_level = 1


func save_game(data: Dictionary) -> void:
	current_save = data
	var file = File.new()
	if file.open(_save_path, File.WRITE) == OK:
		file.store_var(data)
		file.close()


func load_game() -> void:
	var file = File.new()
	if file.open(_save_path, File.READ) == OK:
		current_save = file.get_var(true)
		file.close()
	else:
		save_game(current_save)