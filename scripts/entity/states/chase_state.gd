class_name ChaseState extends State

func _ready() -> void:
	state_name = CHASE;

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	ai_base.detection_area.body_entered.connect(_on_body_entered)
	ai_base.anim.play(ai_base.anim_run);

func _on_body_entered(body : Node) -> void:
	if body is FreeroamController:
		var distance = ai_base.global_position.distance_to(body.global_position)
		if distance <= ai_base.detection_radius:
			ai_base.target_player = body
			transitioned.emit(ATTACK)

func exit() -> void:
	if ai_base.detection_area.body_entered.is_connected(_on_body_entered):
		ai_base.detection_area.body_entered.disconnect(_on_body_entered)
