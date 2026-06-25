class_name ChaseState extends State

var chase_timer: float = 0.0
const CHASE_TIMEOUT := 10.0

func _ready() -> void:
	state_name = CHASE

func enter(_char_reference: AI_Base):
	super.enter(_char_reference)
	if !GameModeManager.instance.is_freeroam:  
		transitioned.emit(IDLE)
		return
	ai_base.detection_area.body_entered.connect(_on_body_entered)
	ai_base.anim.play(ai_base.anim_run)
	chase_timer = CHASE_TIMEOUT

	var bodies = ai_base.detection_area.get_overlapping_bodies()
	for body in bodies:
		if body is FreeroamController:
			ai_base.target_player = body
			transitioned.emit(ATTACK)
			return

	_move_toward_office()

func _move_toward_office() -> void:
	var rooms = GameModeManager.instance.all_rooms
	var office: Room = null
	for r in rooms:
		if r.distance_to_office == 0:
			office = r
			break
	if office == null:
		transitioned.emit(ADVANCE)
		return

	var neighbors = ai_base.current_room.get_neighbors(true)
	neighbors = neighbors.filter(func(r: Room): return r.get_available_spot_count() > 0)
	if neighbors.is_empty():
		ai_base.target_room = office
	else:
		ai_base.target_room = neighbors.pick_random()

	if ai_base.target_room != null and ai_base._move_to_target_room():
		ai_base.should_move = true
		ai_base.on_reached_target.connect(_on_reached_room)
	else:
		transitioned.emit(ADVANCE)

func _on_body_entered(body: Node) -> void:
	if body is FreeroamController:
		ai_base.target_player = body
		transitioned.emit(ATTACK)

func _on_reached_room() -> void:
	if ai_base.on_reached_target.is_connected(_on_reached_room):
		ai_base.on_reached_target.disconnect(_on_reached_room)

	var bodies = ai_base.detection_area.get_overlapping_bodies()
	for body in bodies:
		if body is FreeroamController:
			ai_base.target_player = body
			transitioned.emit(ATTACK)
			return

	transitioned.emit(ADVANCE)

func update(delta: float) -> void:
	chase_timer -= delta
	if chase_timer <= 0:
		transitioned.emit(ADVANCE)

func exit() -> void:
	if ai_base.detection_area.body_entered.is_connected(_on_body_entered):
		ai_base.detection_area.body_entered.disconnect(_on_body_entered)
	if ai_base.on_reached_target.is_connected(_on_reached_room):
		ai_base.on_reached_target.disconnect(_on_reached_room)
