class_name FreeroamCam extends Camera3D

@export var mouse_sensitivity := 0.002   # Adjust in inspector
@export var pitch_limit := 70.0          # degrees
@export var ray_length := 1000
@export var collision_mask := 2

@onready var body := get_parent();

func _ready() -> void:
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	_handle_mouse_motion(event);
	
			
func _handle_mouse_motion(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		body.rotate_y(-event.relative.x * mouse_sensitivity)
		var new_pitch = rotation.x - event.relative.y * mouse_sensitivity
		new_pitch = clamp(new_pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))
		rotation.x = new_pitch
