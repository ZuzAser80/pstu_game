extends Node

class_name Room

@export var spots : Array[Node3D];
@export var neighbors : Array[Room];
@export var cameras : Array;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
