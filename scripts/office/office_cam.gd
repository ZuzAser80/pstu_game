extends Camera3D

@export var mouse_sensitivity := 0.002  
@export var pitch_limit := 70.0          
@export var ray_length := 1000
@export var collision_mask := 2
@export var edge_threshold := 0.08;
@export var rotate_speed := 0.8;

var can_interact : bool = true;
var current_collider : CollisionObject3D;

signal clicked_closeup(number : int)
signal on_hover_start(collider);
signal on_hover_end(collider);

func _ready() -> void:
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _handle_hover(event: InputEvent) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
	query.collide_with_areas = true;
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	var collider: Area3D = result.collider as Area3D if result else null
	can_interact = collider != null
			 
	if collider != current_collider:
		if current_collider != null:
			on_hover_end.emit(current_collider)			
		if collider != null:
			on_hover_start.emit(collider)
		current_collider = collider	

func _unhandled_input(event: InputEvent) -> void:
	_handle_hover(event);
	_handle_mouse_button(event);
	
func _process(delta: float) -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var margin = screen_size.x * edge_threshold

	if mouse_pos.x < margin:
		var strength = 1.0 - (mouse_pos.x / margin)  # 0 at center, 1 at edge
		rotation.y += rotate_speed * strength * delta
	elif mouse_pos.x > screen_size.x - margin:
		var dist_from_edge = (screen_size.x - mouse_pos.x) / margin
		var strength = 1.0 - dist_from_edge
		rotation.y -= rotate_speed * strength * delta

func _print(collider: Variant) -> void:
	print("calishe: ", collider)

func _handle_mouse_button(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and can_interact:
		print("_handle_mouse_button: ", current_collider.get_meta("number"))
		clicked_closeup.emit(current_collider.get_meta("number"));
