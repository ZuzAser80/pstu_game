extends Node

class_name Room

@export var spots : Array[Node3D];
@export var neighbors : Array[Room];
@export var targets : Array[Breakable];

@export var distance_to_office : int;

func _get_neighbors_to_advance() -> Array[Room]:
	var res : Array[Room];
	for r in neighbors:
		if r.distance_to_office < distance_to_office:
			res.append(r);
	return res;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
