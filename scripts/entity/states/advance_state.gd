class_name AdvanceState extends State

func _ready() -> void:
	state_name = ADVANCE;

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	print("advance entered")
	if ai_base.current_room.distance_to_office == 1:
		transitioned.emit(CHASE)
		return
	_select_room();
	if ai_base._move_to_target_room():
		ai_base.should_move = true;
		ai_base.on_reached_target.connect(_stop)
		ai_base.anim.play(ai_base.anim_walk);
	else:
		if not ai_base.current_room.targets.is_empty():
			transitioned.emit(ATTACK)
		else:
			transitioned.emit(IDLE)

func _select_room() -> void:
	var neighbors = ai_base.current_room.get_neighbors(!ai_base.retreating)
	neighbors = neighbors.filter(func(r: Room): return r.get_available_spot_count() > 0)
	if neighbors.is_empty():
		neighbors = ai_base.current_room.get_all_neighbors()
		neighbors = neighbors.filter(func(r: Room): return r.get_available_spot_count() > 0)
		ai_base.aggravation += 1
	if neighbors.is_empty():
		ai_base.target_room = null
		return
	ai_base.target_room = neighbors.pick_random();

func _stop() -> void:
	if ai_base.aggravation > 5 and ai_base.retreating:
		ai_base.aggravation += 1;
		ai_base.retreating = false;
	transitioned.emit(IDLE);

func exit():
	print("advance exited")
	if ai_base.on_reached_target.is_connected(_stop):
		ai_base.on_reached_target.disconnect(_stop)
	
