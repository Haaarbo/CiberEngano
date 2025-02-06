extends TextureButton


func _ready() -> void:
	var _a = connect("mouse_entered", self, "_on_mouse_entered")
	var _b = connect("mouse_exited", self, "_on_mouse_exited")


func _on_mouse_entered() -> void:
	var hover_node = get_node("Hover")
	if hover_node && !self.disabled:
		hover_node.show()


func _on_mouse_exited() -> void:
	var hover_node = get_node("Hover")
	if hover_node:
		hover_node.hide()


func _gui_input(event: InputEvent) -> void:
	if self.disabled:
		if event is InputEventMouseButton and event.pressed:
			# Consume the event to prevent losing focus on other buttons
			get_tree().set_input_as_handled()
		self.focus_mode = Control.FOCUS_NONE
	elif not self.disabled:
			self.focus_mode = Control.FOCUS_ALL
