extends MarginContainer

@onready var bounce_b = $VBoxContainer/BounceButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_world.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_bounce_button_pressed() -> void:
	pass # Replace with function body.
	if GlobalNumbers.Bounce:
		GlobalNumbers.Bounce = false
		bounce_b.text = "Funny Bounce: Off"
	else:
		GlobalNumbers.Bounce = true
		bounce_b.text = "Funny Bounce: On"
