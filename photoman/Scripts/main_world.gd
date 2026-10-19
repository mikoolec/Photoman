extends Node3D

@onready var timer = $UI/tasks/VBoxContainer/Label
@onready var tasks_Label = $UI/Tasks
@export var hbox_container_npc:HBoxContainer
@export var hbox_container_task:HBoxContainer
@export var done:Texture2D
var time = 0

@export var sub_viewport: SubViewport
@export var captured_card_scene: PackedScene
@export var player_camera: Camera3D

var tasks_finished: int = 0

@export var npc_photos:Array[Texture2D]
@export var place_photos:Array[Texture2D]

var tasks = [
	["Tree", "RTV", "Planet", "Printer"], 
	["Planet", "EvilTower", "BallTower"], 
	["Fountain", "RTV", "Tree", "Planet"],
	["Planet", "RTV", "Tort", "Fountain", "Tree"],
	["Printer", "Tort", "BallTower", "EvilTower"]
]

var npcs = [
	"NPC1", "NPC2", "NPC3", "NPC4", "NPC5"
]

@export var player = CharacterBody3D
var npc_table:Array = []
var task_table:Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1, 6):
		var can_continue = false
		var osoba
		while !can_continue:
			osoba = RandomNumberGenerator.new().randi_range(0,4)
			can_continue = true
			if npc_table.count("NPC"+str(osoba+1)) == tasks[osoba].size():
				can_continue = false
		can_continue = false
		var wybrane
		print("")
		while !can_continue:
			wybrane = tasks[osoba].pick_random()
			can_continue = true
			for j in range (0, npc_table.size()):
				print(npc_table[j], " ", ( "NPC" + str(osoba + 1) ), " ", task_table[j], " ", wybrane )
				if ( npc_table[j] == ( "NPC" + str(osoba + 1) ) ) and ( task_table[j] == wybrane ):
					can_continue = false
		task_table.append(wybrane)
		npc_table.append(npcs[osoba])
	
	print(npc_table)
	print(task_table)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time+=delta
	var minutes = int(time)/60
	var seconds = int(time)%60
	var text = "{0}:{1}"
	timer.text = text.format(["%02d" % minutes, "%02d" % seconds])
	#tasks_Label.text = "Tasks: " + str(task_table)
	for i in range(0, 5):
		match npc_table[i]:
			"NPC1":
				set_image_in_slot_npc(npc_photos[0],i)
			"NPC2":
				set_image_in_slot_npc(npc_photos[1],i)
			"NPC3":
				set_image_in_slot_npc(npc_photos[2],i)
			"NPC4":
				set_image_in_slot_npc(npc_photos[3],i)
			"NPC5":
				set_image_in_slot_npc(npc_photos[4],i)
			"":
				set_image_in_slot_npc(done,i)
			_:
				print("Nieznany wynik:", npc_table[i])
	
	for i in range(0, 5):
		match task_table[i]:
			"Tree":
				set_image_in_slot_task(place_photos[0],i)
			"RTV":
				set_image_in_slot_task(place_photos[1],i)
			"BallTower":
				set_image_in_slot_task(place_photos[2],i)
			"Fountain":
				set_image_in_slot_task(place_photos[3],i)
			"Planet":
				set_image_in_slot_task(place_photos[4],i)
			"EvilTower":
				set_image_in_slot_task(place_photos[5],i)
			"Tort":
				set_image_in_slot_task(place_photos[6],i)
			"Printer":
				set_image_in_slot_task(place_photos[7],i)
			"":
				set_image_in_slot_task(done,i)
			_:
				print("Nieznany wynik:", task_table[i])
	
	var test:bool = false
	for each in task_table:
		if each != "":
			test = true
			break
	if !test:
		$PauseScreen.pause(true)
	
	
func set_image_in_slot_npc(texture: Texture2D, slot_index: int) -> void:
	if slot_index < hbox_container_npc.get_child_count():
		var slot = hbox_container_npc.get_child(slot_index) as TextureRect
		if slot:
			slot.texture = texture

func set_image_in_slot_task(texture: Texture2D, slot_index: int) -> void:
	if slot_index < hbox_container_task.get_child_count():
		var slot = hbox_container_task.get_child(slot_index) as TextureRect
		if slot:
			slot.texture = texture

func spawn_card_from_viewport() -> void:
	# Pobranie klatki z SubViewporta
	var img = sub_viewport.get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	
	# Instancjonowanie obiektu karty w świecie gry
	var card_instance = captured_card_scene.instantiate()
	get_tree().current_scene.add_child(card_instance)
	
	# Uruchomienie sekwencji
	card_instance.setup_and_start(tex, player_camera)
	if GlobalNumbers.Capture:
		save_viewport_to_png()

#func capture_frame_to_sprite() -> void:
#	# 1. Pobieramy bieżącą teksturę z SubViewporta
#	var viewport_texture = sub_viewport.get_texture()
#	
#	# 2. Pobieramy dane pikselowe z GPU do RAM (Image)
#	var image: Image = viewport_texture.get_image()
#	
#	# 3. Tworzymy całkowicie osobną, statyczną teksturę z tego obrazu
#	var frozen_texture = ImageTexture.create_from_image(image)
#	
#	# 4. Przypisujemy zamrożoną klatkę do Sprite3D
#	target_sprite.texture = frozen_texture
#	print("mam widok")
#	# 5. Uruchamiamy przykładową animację (np. płynne unoszenie i znikanie)
#	animate_captured_sprite()

#func animate_captured_sprite() -> void:
#	# Włączamy widoczność, jeśli obiekt był ukryty
#	target_sprite.show()
#	target_sprite.position = player.position
#	print("powinienem byc u gracza")
#	
#	var tween = create_tween().set_parallel(true)
#	
#	# Przykładowa animacja: uniesienie w górę o 2 jednostki i zanikanie (fade out)
#	tween.tween_property(target_sprite, "position:y", target_sprite.position.y + 2.0, 1.0)
#	tween.tween_property(target_sprite, "modulate:a", 0.0, 4.0)
#	
#	# Po zakończeniu animacji ukrywamy lub usuwamy obiekt
#	await tween.finished
#	target_sprite.hide()
#	target_sprite.modulate.a = 1.0 # Resetujemy przezroczystość dla kolejnego użycia

func save_viewport_to_png(file_name: String = "captured_frame.png") -> void:
	# 1. Pobieramy teksturę i dane pikselowe (Image)
	var texture = sub_viewport.get_texture()
	var image: Image = texture.get_image()
	
	# 2. Wybieramy ścieżkę zapisu:
	# "user://" zapisuje w bezpiecznym folderze danych użytkownika (AppData/Roaming na Windows)
	# Jeśli chcesz zapisać w folderze z plikiem .exe, użyj "res://" lub ścieżki bezwzględnej (OS.get_system_dir)
	var save_path = "res://" + file_name
	
	# Opcjonalnie: Zapis bezpośrednio na Pulpicie gracza
	# var desktop_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	# var save_path = desktop_path.path_join(file_name)
	
	# 3. Zapisujemy plik PNG
	var error = image.save_png(save_path)
	
	if error == OK:
		print("Pomyślnie zapisano plik PNG w: ", ProjectSettings.globalize_path(save_path))
	else:
		print("Błąd podczas zapisywania pliku PNG: ", error)
