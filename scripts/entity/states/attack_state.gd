extends State

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	_select_attack_target()
	#start playing anim or sum


func _select_attack_target() -> void:
	print("selecting target...")
	var target = ai_base.current_room.targets.pick_random()
	print("selected:", target.name)
	target._break()
	if randi_range(0, 2) == 1:
		transitioned.emit("IdleState")
	else:
		transitioned.emit("AdvanceState")
