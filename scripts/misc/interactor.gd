class_name Interactor extends Node3D

@export var ray_length := 1000
@export var collision_mask := 2

@onready var camera : Camera3D = get_parent() as Camera3D;

var can_interact : bool = true;
var current_collider : CollisionObject3D;

signal on_hover_start(collider);
signal on_hover_end(collider);

func _handle_hover(_event: InputEvent) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
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

func _handle_mouse_button(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and can_interact and current_collider.has_method("interact"):		
		var arr : Dictionary[String, Variant]
		for i in current_collider.get_meta_list():
			arr[i] = current_collider.get_meta(i)
		current_collider.interact(arr);
