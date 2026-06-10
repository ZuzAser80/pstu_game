extends Node

@export var highlightables : Dictionary[NodePath, NodePath]

var _resolved : Dictionary[Area3D, Node3D]

func _ready():
	for area_path in highlightables:
		var area := get_node(area_path) as Area3D
		var target := get_node(highlightables[area_path]) as Node3D
		if area and target:
			target.visible = false;
			_resolved[area] = target			

func _turn_on(coll : Area3D):
	if _resolved.has(coll):
		_resolved[coll].visible = true;

func _turn_off(coll : Area3D):
	if _resolved.has(coll):
		_resolved[coll].visible = false;
