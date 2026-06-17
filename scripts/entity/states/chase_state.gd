class_name ChaseState extends State

var timer : Timer;


func _ready() -> void:
	state_name = CHASE;

func enter(_char_reference : AI_Base):
	super.enter(_char_reference)
	activate()
	timer = Timer.new()
	timer.wait_time = ai_base.detection_timer_wait;
	timer.start()
	timer.timeout.connect(activate)
	ai_base.anim.play(ai_base.anim_run);

func activate() -> void:	

	var space_state: PhysicsDirectSpaceState3D = ai_base.get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = ai_base.detection_radius
	#query.transform = global_transform
	query.collision_mask = 4

	var results: Array[Dictionary] = space_state.intersect_shape(query)
	for result in results:
		var collider = result.get("collider")
		if collider is FreeroamController:
			print("::::::")
			pass	

func exit() -> void:
	timer.timeout.disconnect(activate)
