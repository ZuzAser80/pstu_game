extends Camera3D

@export var mouse_sensitivity := 0.002   # Adjust in inspector
@export var pitch_limit := 70.0          # degrees
@export var ray_length := 1000
@export var collision_mask := 2

signal on_interact_hover;
signal on_interact;

var can_interact : bool = true;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	_handle_mouse_motion(event);
	_handle_mouse_button(event);
	
			
func _handle_mouse_motion(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		var new_pitch = rotation.x - event.relative.y * mouse_sensitivity
		new_pitch = clamp(new_pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))
		rotation.x = new_pitch
		
		_handle_hover();
		
func _handle_hover() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
	query.collide_with_areas = true;
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	can_interact = result;
	if result:					
		var collider = result.collider as Area3D
		can_interact = collider;
		if collider:			
			on_interact_hover.emit();
		
func _handle_mouse_button(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = project_ray_origin(mouse_pos)
		var to = from + project_ray_normal(mouse_pos) * ray_length
		var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
		query.collide_with_areas = true;
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		if result:			
			var collider = result.collider as Area3D
			if collider:
				on_interact_hover.emit();
				#print("_handle_mouse_button: ", collider.get_meta("number"))
				
