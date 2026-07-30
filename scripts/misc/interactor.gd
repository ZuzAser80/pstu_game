class_name Interactor extends Node3D

@export var ray_length := 1000
@export var collision_mask := 2
@export var shotgun : Node3D;
@export var crosshair : TextureRect;

@onready var camera : Camera3D = get_parent() as Camera3D;

var can_interact : bool = true;
var current_collider : CollisionObject3D;
var shotgun_out : bool = false;

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
	_handle_shotgun(event)

func _handle_shotgun(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		shotgun_out = !shotgun_out
		shotgun.visible = shotgun_out
		shotgun.process_mode =  Node.PROCESS_MODE_ALWAYS if shotgun.process_mode == Node.PROCESS_MODE_DISABLED else Node.PROCESS_MODE_DISABLED
		crosshair.visible = shotgun_out

func _shotgun_raycast() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var query = PhysicsRayQueryParameters3D.create(from, to, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result and result.collider is AI_Base:
		result.collider.trigger_flee()

func _handle_mouse_button(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if shotgun_out and GameModeManager.instance.inventory_manager.shotgun_shells > 1:
			GameModeManager.instance.inventory_manager.shotgun_shells -= 1
			shotgun_out = false
			shotgun.process_mode = Node.PROCESS_MODE_DISABLED
			crosshair.visible = false
			_shotgun_raycast()
		elif can_interact and current_collider.has_method("interact"):
			var arr : Dictionary[String, Variant]
			for i in current_collider.get_meta_list():
				arr[i] = current_collider.get_meta(i)
			current_collider.interact(arr);
			
