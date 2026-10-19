extends MarginContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = !get_tree().paused 
		visible = get_tree().paused 
		
		if (visible):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_resume_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	visible = get_tree().paused 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_reset_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
