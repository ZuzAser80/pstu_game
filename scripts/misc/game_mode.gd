class_name GameModeManager extends Node

@export var freeroam_controller : FreeroamController;
@export var office_controller : OfficeController;

var is_freeroam := false

func enable_freeroam() -> void:
	freeroam_controller.process_mode = PROCESS_MODE_INHERIT
	freeroam_controller.camera.current = true;
	office_controller.current = false
	office_controller.process_mode = PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_freeroam = true;

func enable_office() -> void:
	office_controller.process_mode = PROCESS_MODE_INHERIT
	office_controller.current = true	
	freeroam_controller.camera.current = false;
	freeroam_controller.process_mode = PROCESS_MODE_DISABLED	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	is_freeroam = false;
	
func swap() -> void:
	if is_freeroam:
		enable_office()
	else:
		enable_freeroam()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		swap()
