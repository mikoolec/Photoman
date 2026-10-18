# PhotoObject.gd
extends Node3D
class_name PhotoObject  # This turns it into a recognizable type in Godot

# Type the name in the inspector (e.g., "Tree", "Chair", "Ancient Statue")
@export var object_id: String = "Unknown Object"
@export var point_value: int = 100
