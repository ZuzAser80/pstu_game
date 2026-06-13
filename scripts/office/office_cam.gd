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
		
func _unhandled_input(event: InputEvent) -> void:
	_handle_mouse_button(event)

func _handle_mouse_button(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and interactor.current_collider != null and interactor.current_collider.has_meta("number"):
		print("_handle_mouse_button: ", interactor.current_collider.name)
		clicked_closeup.emit(interactor.current_collider.get_meta("number"))
