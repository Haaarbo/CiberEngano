extends Node

onready var click_sound = $ClickSound
var current_first_button_node
var all_nodes_in_current_scene = []

func _ready():
	current_first_button_node = get_buttons()
	click_sound.autoplay = false

func _process(delta):
	if current_first_button_node != get_tree().get_first_node_in_group("Button"):
		current_first_button_node = get_buttons()
	check_pressed_buttons()
#	if get_tree().get_first_node_in_group("Button") is not 

func get_buttons() -> Node:
	all_nodes_in_current_scene = get_tree().get_nodes_in_group("Button")
	for button in all_nodes_in_current_scene:
		print("Nó encontrado na cena:", button.name, "(Tipo:", button.get_class(), ")")
	return get_tree().get_first_node_in_group("Button")

func check_pressed_buttons():
	for button in all_nodes_in_current_scene:
		if button.pressed:
			play_sound()
			button.pressed = false

func play_sound():
	if not click_sound.playing:
		click_sound.play()
	print('Pressed')
