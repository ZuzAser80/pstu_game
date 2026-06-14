class_name Distraction extends Node3D

@export var room: Room
@export var radius: float = 5.0

func _ready() -> void:
	if room == null:
		room = _find_parent_room()

func activate() -> void:
	if room == null:
		return

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = radius
	query.transform = global_transform
	query.collision_mask = 1

	var results: Array[Dictionary] = space_state.intersect_shape(query)
	for result in results:
		var collider = result.get("collider")
		if collider is AI_Base:
			_lure_enemy(collider)


func _lure_enemy(enemy: AI_Base) -> void:
	if enemy.state_machine.current_state.state_name != State.CHASE:
		enemy.target_room = room
		enemy.state_machine._transition_to_state(State.INVESTIGATE)


func _find_parent_room() -> Room:
	var parent = get_parent()
	while parent:
		if parent is Room:
			return parent
		parent = parent.get_parent()
	return null


func _on_timer_timeout() -> void:
	activate()
