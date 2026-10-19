extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_reset_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
