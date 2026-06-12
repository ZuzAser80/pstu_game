class_name AdvanceState extends State

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	print("advance entered")
	_select_room();
	ai_base.should_move = true;
	ai_base._move_to_target_room()
	ai_base.on_reached_target.connect(_stop)
	# bububub huyeta

func _select_room() -> void:
	# TODO: make a check if it is near office, then should aggravate instead of moving.
	var neighbors = ai_base.current_room.get_neighbors(!ai_base.retreating)
	if neighbors.is_empty():
		neighbors = ai_base.current_room.get_all_neighbors()
		ai_base.aggravation += 1
		return
	ai_base.target_room = neighbors.pick_random();

func _stop() -> void:
	if ai_base.aggravation > 5 and ai_base.retreating:
		ai_base.aggravation += 1;
		ai_base.retreating = false;
	transitioned.emit(IDLE);

func exit():
	print("advance exited")
	ai_base.on_reached_target.disconnect(_stop)
	
