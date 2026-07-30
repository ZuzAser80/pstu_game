class_name OfficeUIManager extends Node

@export var radio_button : Area3D
@export var first_floor_buttons : Node
@export var second_floor_buttons : Node
@export var night_time_label : Label
@export var day_time_label : Label
@export var power_label : Label
@export var money_label : Label

var second_floor : bool = true

func set_time_display(text: String) -> void:
	night_time_label.text = text
	day_time_label.text = text

func set_power_display(pct: int) -> void:
	power_label.text = "PWR  %d%%" % pct

func set_money_display(amount: int) -> void:
	money_label.text = "$%d" % amount

func floor_swap() -> void:
	if second_floor:
		second_floor_buttons.process_mode = Node.PROCESS_MODE_DISABLED
		first_floor_buttons.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		second_floor_buttons.process_mode = Node.PROCESS_MODE_INHERIT
		first_floor_buttons.process_mode = Node.PROCESS_MODE_DISABLED
	second_floor = !second_floor

func on_camera_switched(radio_active: bool) -> void:
	radio_button.process_mode = Node.PROCESS_MODE_INHERIT if radio_active else Node.PROCESS_MODE_DISABLED
