extends Button


export(String) var translation_key: String


func _ready() -> void:
	update_text()


func update_text() -> void:
	var translated_text = tr(translation_key)
	text = translated_text
