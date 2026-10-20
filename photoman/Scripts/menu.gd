extends MarginContainer

@onready var bounce_b = $VBoxContainer/BounceButton
@onready var capture_b = $VBoxContainer/CaptureButton
@onready var exit_b = $VBoxContainer/QuitButton
@onready var sens_b = $VBoxContainer/SensitivityButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if OS.has_feature("web"):
		# Logika tylko dla wersji przeglądarkowej (np. ukryj przycisk Exit)
		exit_b.hide()
		capture_b.hide()
	elif OS.has_feature("pc"):
		# Logika dla wersji PC
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_world.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_bounce_button_pressed() -> void:
	 # Replace with function body.
	if GlobalNumbers.Bounce:
		GlobalNumbers.Bounce = false
		bounce_b.text = "Funny Bounce: Off"
	else:
		GlobalNumbers.Bounce = true
		bounce_b.text = "Funny Bounce: On"


func _on_capture_button_pressed() -> void:
	 # Replace with function body.
	if GlobalNumbers.Capture:
		GlobalNumbers.Capture = false
		capture_b.text = "Save Photos: Off"
	else:
		GlobalNumbers.Capture = true
		capture_b.text = "Save Photos: On"


func _on_sensitivity_button_pressed() -> void:
	GlobalNumbers.sens = GlobalNumbers.sens + 0.1
	if GlobalNumbers.sens > 1.85:
		GlobalNumbers.sens = 0.2
	sens_b.text = "Mouse Sensitivity: " + str(GlobalNumbers.sens)
