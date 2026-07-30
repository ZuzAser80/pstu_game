class_name IdleState extends State

func _ready() -> void:
	state_name = IDLE;

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	ai_base.idle_timer.start();
	ai_base.idle_timer.timeout.connect(try_move);
	ai_base.anim.play(ai_base.anim_idle);

func try_move() -> void:
	if randi_range(0, 5) == 1:
		transitioned.emit(ATTACK);
		return
	if (randi_range(0, 100) <= ai_base.hostility_level * 5):
		transitioned.emit(ADVANCE);
		return
	# TODO: add retreat???
	# TODO: make proper formulas, tired of magic numbers already ngl


func exit():
	ai_base.idle_timer.stop();
	ai_base.idle_timer.timeout.disconnect(try_move);
