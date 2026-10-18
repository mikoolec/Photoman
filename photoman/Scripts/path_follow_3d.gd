extends PathFollow3D

@export var speed: float = 0.2 # Adjust how fast it moves

func _process(delta: float) -> void:
	# Smoothly increase progress along the path frame-by-frame
	progress_ratio += speed * delta
	
	# Loop back to the start if it hits the end
	if progress_ratio >= 1.0:
		progress_ratio = 0.0
