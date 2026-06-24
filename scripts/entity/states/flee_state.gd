class_name FleeState extends State

func _ready() -> void:
	state_name = FLEE

func enter(_char_reference: AI_Base):
	super.enter(_char_reference)
	var player = GameModeManager.instance.freeroam_controller
	if player == null:
		transitioned.emit(IDLE)
		return
	_select_flee_room(player.global_position)
	if ai_base.target_room != null and ai_base._move_to_target_room():
		ai_base.should_move = true
		ai_base.on_reached_target.connect(_stop)
		ai_base.anim.play(ai_base.anim_run)
	else:
		transitioned.emit(IDLE)

func _select_flee_room(player_pos: Vector3) -> void:
	var neighbors = ai_base.current_room.get_all_neighbors()
	var available = neighbors.filter(func(r: Room): return r.get_available_spot_count() > 0)
	if available.is_empty():
		available = neighbors
	var farthest: Room = null
	var farthest_dist: float = -1.0
	for r in available:
		var dist = r.global_position.distance_to(player_pos)
		if dist > farthest_dist:
			farthest_dist = dist
			farthest = r
	ai_base.target_room = farthest

func _stop() -> void:
	transitioned.emit(IDLE)

func exit() -> void:
	if ai_base.on_reached_target.is_connected(_stop):
		ai_base.on_reached_target.disconnect(_stop)
