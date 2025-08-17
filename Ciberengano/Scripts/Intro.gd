extends Control

var toque_contador := 0
onready var zoom := $Escola/zoom
onready var som_sinal := $Sinal_Escola

func _ready():
	zoom.playing = false


func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		toque_contador += 1

		if toque_contador == 1:
			print("Primeiro toque - tocando animação")
			zoom.play("intro") # Troque pelo nome real da animação


func _on_zoom_animation_finished():
	get_tree().change_scene("res://Scenes/Game.tscn")
	if get_tree().paused:
		get_tree().paused = false
