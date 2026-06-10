extends State

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	print("advance entered")
	_select_room();
	ai_base.should_move = true;
	ai_base.on_reached_target.connect(_stop)
	# bububub huyeta

func _select_room() -> void:
	# TODO: make a check if it is near office, then should aggravate instead of moving.
	ai_base.target_room = ai_base.current_room._get_neighbors_to_advance().pick_random();

func _stop() -> void:
	transitioned.emit("IdleState");

func exit():
	print("advance exited")
	
