class_name OfficeController extends Camera3D

@export var mouse_sensitivity := 0.002  
@export var pitch_limit := 70.0          
@export var edge_threshold := 0.08;
@export var rotate_speed := 0.8;

signal clicked_closeup(number : int)

@onready var interactor := $Interactor

func _process(delta: float) -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var margin = screen_size.x * edge_threshold

	if mouse_pos.x < margin:
		var strength = 1.0 - (mouse_pos.x / margin)
		rotation.y += rotate_speed * strength * delta
	elif mouse_pos.x > screen_size.x - margin:
		var dist_from_edge = (screen_size.x - mouse_pos.x) / margin
		var strength = 1.0 - dist_from_edge
		rotation.y -= rotate_speed * strength * delta
