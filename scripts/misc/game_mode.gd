class_name GameModeManager extends Node

@export var freeroam_controller : FreeroamController;
@export var office_controller : OfficeController;
@export var night_light : DirectionalLight3D
@export var day_light : DirectionalLight3D
@onready var timer := $Timer
@export var start_shells : int;
@export var start_cam_repair_kit : int;
@export var start_radio : int;

static var shotgun_sheels : int = 0
static var cam_repair_kit : int = 1
static var radio : int = 0

var is_freeroam := false
@export var hours : int
@export var minutes : int
#@onready static var office_ui : OfficeUIController = $OfficeUIController

func _ready() -> void:
	shotgun_sheels = start_shells;
	cam_repair_kit = start_cam_repair_kit;
	radio = start_radio;
	timer.timeout.connect(func (): hours -= 1);
	pass

func _process(delta: float) -> void:
	#call ui update 4 hrs and mins
	
	pass
	

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
	if event is InputEventKey and event.pressed and event.keycode == KEY_F:
		swap()
