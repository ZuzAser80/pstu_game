class_name Distraction extends Node3D

@export var room: Room
@export var radius: float = 5.0
@export var activation_delay: float = -1.0
@export var one_shot: bool = true

var _triggered: bool = false
var _timer: Timer


func _ready() -> void:
	if room == null:
		room = _find_parent_room()
	if activation_delay >= 0.0:
		_timer = Timer.new()
		add_child(_timer)
		_timer.one_shot = true
		_timer.timeout.connect(_on_timer_timeout)
		_timer.start(activation_delay)


func activate() -> void:
	if _triggered and one_shot:
		return
	if room == null:
		return
	_triggered = true

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
	enemy.target_room = room
	var state_machine: StateMachine = enemy.get_node("NavigationAgent3D/StateMachine")
	state_machine._transition_to_state("InvestigateState")


func _find_parent_room() -> Room:
	var parent = get_parent()
	while parent:
		if parent is Room:
			return parent
		parent = parent.get_parent()
	return null


func _on_timer_timeout() -> void:
	activate()
