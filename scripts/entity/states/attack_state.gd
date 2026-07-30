class_name AttackState extends State

func _ready() -> void:
	state_name = ATTACK;

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	ai_base.anim.play(ai_base.anim_idle);
	if ai_base.target_player != null:
		_attack_player()
	else:
		_select_attack_target()

func _attack_player() -> void:
	GameModeManager.trigger_game_over()

func _select_attack_target() -> void:
	var target = ai_base.current_room.targets.pick_random()
	if target == null: 
		transitioned.emit(IDLE) 
		return
	target._break()
	if target.type == Breakable.BreakableType.Door and ai_base.target_player != null:
		transitioned.emit(CHASE)
		return
	if randi_range(0, 2) == 1:
		transitioned.emit(IDLE)
	else:
		transitioned.emit(ADVANCE)
