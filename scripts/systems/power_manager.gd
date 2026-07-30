class_name PowerManager extends Node

signal power_updated(current: float, max: float)
signal power_depleted_changed(depleted: bool)

@export var max_power : float = 100.0
@export var power_drain_cam : float = 5.0
@export var power_drain_radio : float = 10.0
@export var office_ui : OfficeUIManager

static var instance: PowerManager

var current_power : float
var power_depleted : bool = false

func _ready() -> void:
	instance = self
	current_power = max_power
	power_updated.connect(_on_power_updated)

func _on_power_updated(current: float, max: float) -> void:
	if office_ui:
		office_ui.set_power_display(int(current))

func drain_power(amount: float) -> void:
	if power_depleted: return
	current_power = maxf(current_power - amount, 0.0)
	if current_power <= 0:
		power_depleted = true
		power_depleted_changed.emit(true)
	power_updated.emit(current_power, max_power)

func restore_power() -> void:
	current_power = max_power
	power_depleted = false
	power_depleted_changed.emit(false)
	power_updated.emit(current_power, max_power)

func _on_power_switch_interacted(_args: Dictionary) -> void:
	restore_power()
