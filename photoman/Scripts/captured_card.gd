extends Node3D

@onready var sprite: Sprite3D = $Sprite3D
@onready var ray_cast: RayCast3D = $RayCast3D

var velocity_y: float = 0.0
var gravity: float = 12.0
var is_falling: bool = false
var ground_y: float = -999.0

func setup_and_start(frozen_texture: Texture2D, player_camera: Camera3D) -> void:
	sprite.texture = frozen_texture
	
	# 1. Pojawienie się ok. 50 cm (0.5 m) przed kamerą gracza
	var forward = -player_camera.global_transform.basis.z.normalized()
	global_position = player_camera.global_position + forward * 1
	
	look_at(player_camera.global_position, Vector3.UP)
	rotation.x = 0
	rotation.z = 0
	
	_play_pop_animation()

func _play_pop_animation() -> void:
	var tween = create_tween().set_parallel(true)
	
	# 2. Podskok
	var target_up = global_position.y + 0.5
	tween.tween_property(self, "global_position:y", target_up, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# 3. Obrót samej grafiki (Sprite3D), aby RayCast3D pod spodem nie obrócił się w bok!
	var target_rot_x = sprite.rotation.x - PI / 2.0
	tween.tween_property(sprite, "rotation:x", target_rot_x, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	_start_falling()

func _start_falling() -> void:
	velocity_y = 0.0
	is_falling = true

func _process(delta: float) -> void:
	# Aktualizujemy cel lądowania, jeśli pod spodem jest ziemia
	_update_ground_level()

	# Jeśli stoimy na ziemi, ale podłoga nagle zniknie/odjedzie – wznawiamy spadanie
	if not is_falling and global_position.y > ground_y + 0.05:
		is_falling = true

	# Zwykłe spadanie dokładnie jak na początku
	if is_falling:
		velocity_y -= gravity * delta
		global_position.y += velocity_y * delta
		
		if global_position.y <= ground_y:
			global_position.y = ground_y + 0.01
			is_falling = false
			velocity_y = 0.0
			_on_landed()

func _update_ground_level() -> void:
	# Raycast wymuszony w dół niezależnie od obrotu
	ray_cast.global_rotation = Vector3.ZERO
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		ground_y = ray_cast.get_collision_point().y
	else:
		ground_y = -999.0

func _on_landed() -> void:
	print("landed")
