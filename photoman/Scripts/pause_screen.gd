extends MarginContainer

@onready var you_win = $VBoxContainer/YouWin
@onready var time = $VBoxContainer/Time
@onready var resume = $VBoxContainer/Resume
@onready var unstuck = $VBoxContainer/Unstuck
@export var player: CharacterBody3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Escape"):
		pause()

func pause(won: bool = false) -> void:
	print("h")
	get_tree().paused = !get_tree().paused 
	visible = get_tree().paused 
	
	if (won):
		resume.visible = false
		you_win.visible = true
		time.visible = true
		unstuck.visible = false
		var timer_time = get_parent().time
		var minutes = int(timer_time)/60
		var seconds = int(timer_time)%60
		var text = "{0}:{1}"
		time.text = "Time: " + text.format(["%02d" % minutes, "%02d" % seconds])
		get_tree().paused = true
		visible = true
	else:
		resume.visible = true
		you_win.visible = false
		time.visible = false
		unstuck.visible = true
		
	if (visible):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _on_resume_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	visible = get_tree().paused 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.flush_buffered_events() 
	get_viewport().set_input_as_handled()


func _on_reset_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()

func _on_unfuck_pressed() -> void:
	player._unstuck()
	get_tree().paused = !get_tree().paused 
	visible = get_tree().paused 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.flush_buffered_events() 
	get_viewport().set_input_as_handled()

func _on_exit_pressed() -> void:
	get_tree().paused = !get_tree().paused 
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
