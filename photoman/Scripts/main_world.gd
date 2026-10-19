extends Node3D

@onready var timer = $UI/Label
@onready var tasks_Label = $UI/Tasks
var time = 0

var tasks = [
	["Tree", "RTV Tower", "Planet", "Printer"], 
	["Planet", "New Tower", "7G Tower"], 
	["Fountain", "RTV Tower", "Tree", "Planet"]
]

var task_table:Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in tasks:
		task_table.append(i.pick_random())
	print(task_table)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time+=delta
	var minutes = int(time)/60
	var seconds = int(time)%60
	var text = "{0}:{1}"
	timer.text = text.format(["%02d" % minutes, "%02d" % seconds])
	tasks_Label.text = "Tasks: " + str(task_table)
	
	
