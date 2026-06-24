class_name OfficeUIController extends Node

@export var time_text_label : Label
@export var radio_button : Area3D 
@export var first_floor_buttons : Node
@export var second_floor_buttons : Node

static var stat_radio
var second_floor : bool = true;

func _ready() -> void:
	stat_radio = radio_button

func set_time() -> void:
	
	pass

func _floor_swap() -> void: 
	if second_floor:
		second_floor_buttons.process_mode = Node.PROCESS_MODE_DISABLED
		first_floor_buttons.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		second_floor_buttons.process_mode = Node.PROCESS_MODE_INHERIT
		first_floor_buttons.process_mode = Node.PROCESS_MODE_DISABLED
	second_floor = !second_floor

static func on_camera_switched(radio_active : bool) -> void:
	stat_radio.process_mode = Node.PROCESS_MODE_INHERIT if radio_active else Node.PROCESS_MODE_DISABLED
	pass
