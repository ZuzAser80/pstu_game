class_name OfficeUIController extends Node

@export var time_text_label : Label
@export var radio_button : Area3D 

static var stat_radio

func _ready() -> void:
	stat_radio = radio_button

func set_time() -> void:
	
	pass

static func on_camera_switched(radio_active : bool) -> void:
	stat_radio.process_mode = Node.PROCESS_MODE_INHERIT if radio_active else Node.PROCESS_MODE_DISABLED
	pass
