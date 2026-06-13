class_name InvestigateState extends State


func enter(_char_reference : AI_Base):
	super.enter(_char_reference);
	if ai_base.target_room == null:
		transitioned.emit(IDLE)
		return
	ai_base.should_move = true
	ai_base._move_to_target_room()
	ai_base.on_reached_target.connect(_stop)

func _stop() -> void:
	transitioned.emit(IDLE)

func exit() -> void:
	if ai_base.on_reached_target.is_connected(_stop):
		ai_base.on_reached_target.disconnect(_stop)
