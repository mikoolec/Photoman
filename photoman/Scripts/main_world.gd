extends Node3D

@onready var timer = $UI/Label
@onready var tasks_Label = $UI/Tasks
@export var hbox_container_npc:HBoxContainer
@export var hbox_container_task:HBoxContainer
@export var done:Texture2D
var time = 0

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
