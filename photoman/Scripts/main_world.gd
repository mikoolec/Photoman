extends Node3D

@onready var timer = $UI/Label
@onready var tasks_Label = $UI/Tasks
var time = 0

var tasks_finished: int = 0

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
		var osoba = RandomNumberGenerator.new().randi_range(0,4)
		task_table.append(tasks[osoba].pick_random())
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
	tasks_Label.text = "Tasks: " + str(task_table)
	var test:bool = false
	for each in task_table:
		if each != "":
			test = true
			break
	if !test:
		$PauseScreen.pause(true)
	
	
