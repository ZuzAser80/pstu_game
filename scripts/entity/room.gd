extends Node3D

class_name Room

@export var spots : Array[Node3D];
@export var neighbors : Array[Room];
@export var targets : Array[Breakable];
@onready var distraction := $Distraction;

@export var distance_to_office : int;

var reserved_spots : Array[Node3D] = [];

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

func get_available_spot() -> Node3D:
	var available : Array[Node3D] = [];
	for spot in spots:
		if spot not in reserved_spots:
			available.append(spot);
	if available.is_empty():
		return null;
	return available.pick_random();

func get_available_spot_count() -> int:
	var count := 0;
	for spot in spots:
		if spot not in reserved_spots:
			count += 1;
	return count;

func reserve_spot(spot: Node3D) -> void:
	if spot not in reserved_spots:
		reserved_spots.append(spot);

func release_spot(spot: Node3D) -> void:
	reserved_spots.erase(spot);
