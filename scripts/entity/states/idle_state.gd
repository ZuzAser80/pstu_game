extends State

# Called when the node enters the scene tree for the first time.
func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	print("idle entered")
	ai_base.idle_timer.start();
	ai_base.idle_timer.timeout.connect(try_move);
	#ai_base.anim.play();

func try_move() -> void:
	if (randi_range(0, 100) * ai_base.hostility_level >= ai_base.hostility_level * 10):
		print("random check success, moving.")
		transitioned.emit("AdvanceState");
	# TODO: add camera breaking and retreat???
	# TODO: make proper formulas, tired of magic numbers already ngl
	if ai_base.aggravation * ai_base.hostility_level >= 50:
		print("aggravated, breaking")
		transitioned.emit("AttackState");

func exit():
	print("idle exited")
	ai_base.idle_timer.stop();
