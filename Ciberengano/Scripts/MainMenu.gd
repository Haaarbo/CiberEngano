extends CanvasLayer

var settings_scene := preload("res://Scenes/SettingsMenu.tscn")

onready var animation_player = get_node("Transition/AnimationPlayer")
func _ready() -> void:
	animation_player.play("FadeIn")

	if not Music.playing:
		Music.play()

	var current_locale = TranslationServer.get_locale()
	if current_locale == "pt_BR":
		$PtBrButton.hide()
		$EnUsButton.show()
	else:
		$PtBrButton.show()
		$EnUsButton.hide()
		
	Save.load_game()
	if Save.current_save["player_level"] <= 3:
		var infinite_button = get_node("LevelsContainer/InfiniteButton")
		infinite_button.disabled = true

	if Save.current_save["player_level"] <= 2:
		var level_3_button = get_node("LevelsContainer/Level3Button")
		level_3_button.disabled = true
		
	if Save.current_save["player_level"] <= 1:
		var level_2_button = get_node("LevelsContainer/Level2Button")
		level_2_button.disabled = true
	
	var score = Save.current_save["score"]
	for level in score.keys():
		var current_level_score = score[level]
		if current_level_score >= 1000:
			var current_level_stars = floor(current_level_score / 1000)
			var current_level_texture_path = "res://Assets/UI/level_buttons/%s/%s_stars.png" % [level, str(current_level_stars)]
			var current_level_texture = load(current_level_texture_path)
			var formatted_level = level.capitalize().replace(" ", "")
			var current_node_path = "LevelsContainer/%sButton" % formatted_level
			get_node(current_node_path).texture_normal = current_level_texture
	
	var endless_score = Save.current_save["endless_score"]
	if endless_score > 0:
		var endless_texture = load("res://Assets/UI/level_buttons/endless/some_points.png")
		get_node("LevelsContainer/InfiniteButton").texture_normal = endless_texture
		var endless_score_label = get_node("LevelsContainer/InfiniteButton/InfiniteScore")
		endless_score_label.text = _format_number(endless_score)
		endless_score_label.show()

	var level_1_button = get_node("LevelsContainer/Level1Button")
	level_1_button.grab_focus()


func _on_StartButton_pressed() -> void:
	ClickSound.play_sound()
	var _level = _get_focused_button()
	if !_level: return
	var _level_number = _extract_level_number(_level)
	Save.selected_level = _level_number
	var level_scene_path = "res://Scenes/Level%d.tscn" % _level_number
	var level_scene := load(level_scene_path)
	var _err := get_tree().change_scene_to(level_scene)


onready var transition = get_node("Transition")
func _on_SettingsButton_pressed() -> void:
	transition.connect("animation_finished", self, "_on_animation_finished", [settings_scene])
	animation_player.play("FadeOut")
	transition.play()


func _on_animation_finished(scene: PackedScene) -> void:
	transition.disconnect("animation_finished", self, "_on_animation_finished")
	animation_player.stop(true)
	var _err := get_tree().change_scene_to(scene)


func _on_PtBrButton_pressed() -> void:
	TranslationServer.set_locale("pt_BR")
	$PtBrButton.hide()
	$EnUsButton.show()
	_update_buttons_text()


func _on_EnUsButton_pressed() -> void:
	TranslationServer.set_locale("en_US")
	$PtBrButton.show()
	$EnUsButton.hide()
	_update_buttons_text()


func _update_buttons_text() -> void:
	var start_button := get_node("ButtonsContainer/StartButton")
	start_button.update_text()


func _format_number(num: int) -> String:
	var num_str = str(num)
	if num_str.length() > 5:
		return "99999"
	
	while num_str.length() < 5:
		num_str = "0" + num_str
	
	return num_str


func _get_focused_button():
	var container = get_node("LevelsContainer")
	if container:
		for button in container.get_children():
			if button is TextureButton and button.has_focus():
				return button.name
	return null


func _extract_level_number(level_name: String) -> int:
	var level_number = level_name.replace("Level", "").replace("Button", "")
	return int(level_number)
