class_name GameModeManager extends Node

enum Phase { DAY, NIGHT }

const NIGHT_DURATION := 480.0
const DAY_DURATION := 300.0

@export var freeroam_controller : FreeroamController;
@export var office_controller : OfficeController;
@export var night_light : DirectionalLight3D
@export var day_light : DirectionalLight3D
@export var night_time_label : Label
@export var day_time_label : Label
@export var power_label : Label
@export var max_power : float = 100.0
@export var power_drain_cam : float = 5.0
@export var power_drain_radio : float = 10.0
@export var start_shells : int;
@export var start_cam_repair_kit : int;
@export var start_radio : int;
@export var ai_list : Array[AI_Base]
@export var all_rooms : Array[Room]
@export var camera_system : CameraSystem

static var instance: GameModeManager
static var shotgun_sheels : int = 0
static var cam_repair_kit : int = 1
static var radio : int = 0

var is_freeroam := false
var current_phase: Phase = Phase.DAY
var phase_time: float = 0.0
var current_power: float
var power_depleted: bool = false

func _ready() -> void:
	instance = self
	current_power = max_power
	shotgun_sheels = start_shells;
	cam_repair_kit = start_cam_repair_kit;
	radio = start_radio;
	_update_phase()

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
	night_time_label.visible = is_night
	day_time_label.visible = not is_night

	power_depleted = false
	if is_night:
		current_power = max_power
		enable_office()
		for ai in ai_list:
			ai.process_mode = PROCESS_MODE_INHERIT
			ai.respawn_at_farthest_room()
			ai.state_machine._transition_to_state(State.IDLE)
	else:
		enable_freeroam()
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
	night_time_label.text = text
	day_time_label.text = text
	power_label.text = "PWR  %d%%" % [current_power]

static func drain_power(amount: float) -> void:
	if instance and not instance.power_depleted:
		instance.current_power -= amount
		if instance.current_power <= 0:
			instance.current_power = 0
			instance.power_depleted = true
			instance.enable_freeroam()

static func trigger_game_over() -> void:
	if instance:
		instance.get_tree().change_scene_to_file("res://scenes/game_over.tscn")

static func restore_power() -> void:
	if instance:
		instance.current_power = instance.max_power
		instance.power_depleted = false

func _on_power_switch_interacted(_args: Dictionary) -> void:
	restore_power()

func _on_office_door_interacted(_args: Dictionary) -> void:
	if current_phase == Phase.NIGHT and not power_depleted:
		enable_office()

func _on_radio_place_interacted(args: Dictionary) -> void:
	if radio <= 0:
		return
	radio -= 1
	var cam_index = args.get("camera_index", -1)
	if cam_index < 0 or cam_index >= camera_system.cameras.size():
		return
	var room_name = args.get("room_name", "")
	if room_name.is_empty():
		return
	var room = get_node("../" + room_name) as Room
	if not room:
		return
	var cam = camera_system.cameras[cam_index]
	room.distraction.process_mode = PROCESS_MODE_INHERIT
	camera_system.cam_to_room[cam] = room
	for child in room.get_children():
		if child is Area3D and child.name == "RadioPlacementSpot":
			child.process_mode = PROCESS_MODE_DISABLED
			child.visible = false
			break

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
