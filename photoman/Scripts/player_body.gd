extends CharacterBody3D

@export var SPEED_ref = 5.0
@export var MOUSE_SENSITIVITY_ref = 0.01
@export var bob_amp_ref = 0.08


var SPEED = SPEED_ref
const JUMP_VELOCITY = 4.5
const GRAVITY = 2
var MOUSE_SENSITIVITY = MOUSE_SENSITIVITY_ref

@onready var head = $HeadNode
@onready var camera = $HeadNode/Camera3D

const bob_freq = 2.0
var bob_amp = bob_amp_ref
var t_bob = 0.0

const angle_mul = 0.2

#moje
@export var aparat:Node3D
@export var world_node:Node3D

var aparat_held:bool = false
var can_shoot:bool = true
@onready var aparat_nodes = $AparatNodes
@onready var aparatheld_pos = $AparatNodes/AparatHeld
@onready var aparatluz_pos = $AparatNodes/AparatLuz

@onready var aparats_camera = $aparat/SubViewport/Camera3D
@onready var aparat_anim = $aparat/AnimationPlayer
@onready var beepPlayer = $aparat/ShutterBeeper
@onready var shutter = $aparat/Shutter
@onready var subViewport = $aparat/SubViewport



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	shutter.finished.connect(_on_shutter_finished)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(59))
		aparat.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		aparat.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(59))
		#aparat_nodes.rotate_x((-event.relative.y * MOUSE_SENSITIVITY))
		

		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	var pos = aparatheld_pos.position
	pos.y += tan(aparat.rotation.x*0.8)*abs(pos.z)
	pos.z += abs(abs(pos.z)/cos(aparat.rotation.x*0.8))-abs(pos.z)
	#print(pos.z)
	
	if Input.is_action_just_pressed("LMB"):
		print("zaczynam trzymac lmb, wyjmij aparat")
		MOUSE_SENSITIVITY *= 0.1
		SPEED *= 0.4
		bob_amp *= 0.2
		
		
		#pos.z += cos(aparat.rotation.x)*0.05
		aparat_held = true
		beepPlayer.play()
		
	if aparat_held:
		_funky_tween(aparat, "position", pos, 0.2)
	
	if Input.is_action_just_released("LMB"):
		print("puscilem aparat, schowaj")
		MOUSE_SENSITIVITY = MOUSE_SENSITIVITY_ref
		SPEED = SPEED_ref
		bob_amp *= bob_amp_ref
		_funky_tween(aparat, "position", aparatluz_pos.position, 0.2)
		aparat_held = false
	
	
	
	if aparat_held && Input.is_action_just_pressed("RMB") && can_shoot:
		can_shoot = false
		print("kliknieto rmb trzymajac aparat, zrob zdjecie")
		shutter.play()
		aparat_anim.play("Click")
		subViewport.render_target_update_mode = SubViewport.UPDATE_ONCE
		var tab = aparats_camera.scan_visible_objects()
		print(tab)
		for i in range(0,5):
			for each in tab:
				if each["name"].contains("NPC"):
					if world_node.npc_table[i] == each["name"]:
						for each2 in tab:
							if each2["name"] == world_node.task_table[i]:
								world_node.npc_table[i] = ""
								world_node.task_table[i] = ""
						
						
						#for npc_target in get_parent().npc_table:
						#	if npc_target == each["name"]:
						#		if get_parent().task_table()[get_parent().npc_table.find( npc_target )] == each2["name"]:
						#			get_parent().task_table[i-1] = ""
						#			get_parent().task_table[i-1] = ""
						#			print("Zrobione")
						#print(get_parent().task_table[i-1])
						#if each2["name"] == get_parent().task_table[i-1]:
						#	get_parent().task_table[i-1] = ""
						#	print("Zrobione")
					#print("Mamy gówniarza nr "+str(i))
		
	
	move_and_slide()
	
	_check_fall()

func _on_shutter_finished() -> void:
	print("The shutter sound has finished playing completely!")
	subViewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	can_shoot = true
	
func _check_fall() -> void:
	if position.y < -12.0:
		#velocity.y = 30
		
		#ZMIENIC NA DOLNE PRZED SKONCZENIEM
		
		velocity = Vector3.ZERO
		position = Vector3(25.77, 2.192, -25.7)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	return pos

func _funky_tween(what, how, where, time):
	var tween = create_tween()
	tween.tween_property(what, how, where, time)
