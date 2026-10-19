extends Node3D

@onready var timer = $UI/Label
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time+=delta
	var minutes = int(time)/60
	var seconds = int(time)%60
	var text = "{0}:{1}"
	timer.text = text.format(["%02d" % minutes, "%02d" % seconds])
