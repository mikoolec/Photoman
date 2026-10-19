extends PathFollow3D

@export var speed: float = 0.2

func _process(delta: float) -> void:
	var old_pos = global_position
	
	# Zwiększamy ruch
	progress_ratio += speed * delta
	if progress_ratio >= 1.0:
		progress_ratio = 0.0
		
	# Kierunek ruchu w płaszczyźnie poziomej (X-Z)
	var dir = global_position - old_pos
	dir.y = 0.0 # Ignorujemy góra/dół!
	
	if dir.length_squared() > 0.0001:
		# Obracamy dzieci w przestrzeni świata wokół osi Y
		for child in get_children():
			if child is Node3D:
				child.global_rotation.x = 0.0
				child.global_rotation.z = 0.0
				child.global_rotation.y = atan2(dir.x, dir.z) + deg_to_rad(180)
