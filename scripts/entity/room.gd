extends Node3D

class_name Room

@export var spots : Array[Node3D];
@export var neighbors : Array[Room];
@export var targets : Array[Breakable];
@onready var distraction := $Distraction;

@export var distance_to_office : int;

func get_neighbors(advance : bool) -> Array[Room]:
	var res : Array[Room];
	for r in neighbors:
		if advance:
			if r.distance_to_office < distance_to_office:
				res.append(r);
		else:
			if r.distance_to_office >= distance_to_office:
				res.append(r);
	return res;

func get_all_neighbors() -> Array[Room]:
	return neighbors
