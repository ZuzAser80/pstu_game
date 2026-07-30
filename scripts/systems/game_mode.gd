class_name GameModeManager extends Node

enum Phase { DAY, NIGHT }

const NIGHT_DURATION := 480.0
const DAY_DURATION := 300.0

@export var inventory_manager : InventoryManager
@export var power_manager : PowerManager
@export var office_ui : OfficeUIManager
@export var freeroam_ui : FreeroamUIManager
@export var freeroam_controller : FreeroamController
@export var office_controller : OfficeController
@export var night_light : DirectionalLight3D
@export var day_light : DirectionalLight3D
@export var ai_list : Array[AI_Base]
@export var all_rooms : Array[Room]
@export var camera_system : CameraSystem
@export var shop : Shop

static var instance: GameModeManager

const NIGHT_REWARD := 10

var is_freeroam := false
var current_phase: Phase = Phase.DAY
var day_number := 0;
var phase_time: float = 0.0

func _ready() -> void:
	instance = self
	shop.shop_closed.connect(_on_shop_closed)
	power_manager.power_depleted_changed.connect(_on_power_depleted_changed)
	shop.visible = false
	call_deferred("_delayed_start")

func _process(delta: float) -> void:
	phase_time += delta
	var duration = NIGHT_DURATION if current_phase == Phase.NIGHT else DAY_DURATION
	if phase_time >= duration:
		phase_time = 0.0
		current_phase = Phase.NIGHT if current_phase == Phase.DAY else Phase.DAY
		_update_phase()
	_update_time_display()

func _update_phase() -> void:
	var is_night = current_phase == Phase.NIGHT
	day_light.visible = not is_night
	night_light.visible = is_night
	office_ui.night_time_label.visible = is_night
	office_ui.day_time_label.visible = not is_night

	if is_night:
		power_manager.restore_power()
		enable_office()
		for ai in ai_list:
			ai.process_mode = PROCESS_MODE_INHERIT
			ai.respawn_at_farthest_room()
			ai.state_machine._transition_to_state(State.IDLE)
	else:
		if day_number > 0:
			inventory_manager.money += NIGHT_REWARD
		day_number += 1
		enable_freeroam()
		shop.open()
		for ai in ai_list:
			ai.process_mode = PROCESS_MODE_DISABLED

func _update_time_display() -> void:
	var remaining: float
	var prefix: String
	if current_phase == Phase.NIGHT:
		remaining = NIGHT_DURATION - phase_time
		prefix = "NIGHT"
	else:
		remaining = DAY_DURATION - phase_time
		prefix = "DAY"
	var m = int(remaining) / 60
	var s = int(remaining) % 60
	var text = "%s  %02d:%02d" % [prefix, m, s]
	office_ui.set_time_display(text)
	office_ui.set_money_display(inventory_manager.money)

func _on_power_depleted_changed(depleted: bool) -> void:
	if depleted:
		enable_freeroam()

static func trigger_game_over() -> void:
	if instance:
		instance.get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_office_door_interacted(_args: Dictionary) -> void:
	if current_phase == Phase.DAY:
		current_phase = Phase.NIGHT
		phase_time = 0.0
		_update_phase()
	elif is_freeroam:
		if not power_manager.power_depleted:
			enable_office()

func _delayed_start() -> void:
	_update_phase()

func _on_shop_closed() -> void:
	shop.visible = false

func _on_radio_place_interacted(args: Dictionary) -> void:
	if inventory_manager.radio <= 0:
		return
	inventory_manager.radio -= 1
	var cam_index = args.get("camera_index", -1)
	if cam_index < 0 or cam_index >= camera_system.cameras.size():
		return
	var room_name = args.get("room_name", "")
	if room_name.is_empty():
		return
	var room = get_node("../" + room_name) as Room
	if not room:
		return
	room.distraction.process_mode = PROCESS_MODE_INHERIT
	for child in room.get_children():
		if child is Area3D and child.name == "RadioPlacementSpot":
			child.process_mode = PROCESS_MODE_DISABLED
			child.visible = false
			break

func enable_freeroam() -> void:
	freeroam_controller.process_mode = PROCESS_MODE_INHERIT
	freeroam_controller.camera.current = true
	office_controller.current = false
	office_controller.process_mode = PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_freeroam = true

func enable_office() -> void:
	office_controller.process_mode = PROCESS_MODE_INHERIT
	office_controller.current = true
	freeroam_controller.camera.current = false
	freeroam_controller.process_mode = PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	is_freeroam = false
	freeroam_ui.refresh_inventory(inventory_manager.shotgun_shells, inventory_manager.cam_repair_kit, inventory_manager.radio)
