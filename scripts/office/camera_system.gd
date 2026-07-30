class_name CameraSystem extends Node

@export var power_manager : PowerManager
@export var office_ui : OfficeUIManager
@export var cameras : Array[Room];
@export var no_visual : Texture2D
@export var display : Sprite3D
@export var close_up : Sprite2D

var close_up_open := false
var currentIndex := 0;

func _refresh() -> void:
	if cameras[currentIndex].camera.get_meta("visual"):
		var viewport_texture = cameras[currentIndex].camera.get_texture();
		close_up.texture = viewport_texture;	
		display.texture = viewport_texture;
	else:
		close_up.texture = no_visual;
		display.texture = no_visual;

func radio_active() -> bool:
	return cameras[currentIndex].distraction != null;

func trigger_radio(number: Dictionary[String, Variant]) -> void:	
	power_manager.drain_power(power_manager.power_drain_radio)
	if radio_active():
		cameras[currentIndex].distraction.activate()
		
func repair_radio(number : Dictionary[String, Variant]) -> void:
	cameras[currentIndex].distraction.set_meta("enabled", true)
	pass

func move_to_cam(index: int) -> void:	
	currentIndex = index;
	office_ui.on_camera_switched(radio_active())
	_refresh();

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		close_up_open =  false;
		close_up.texture = null;

func trigger_cam(number: Dictionary[String, Variant]) -> void:
	power_manager.drain_power(power_manager.power_drain_cam)
	close_up_open = true;
	move_to_cam(number["number"] as int);

func repair_cam(args: Dictionary[String, Variant]) -> void:
	if args.has("number") and GameModeManager.instance.inventory_manager.cam_repair_kit > 0:
		GameModeManager.instance.inventory_manager.cam_repair_kit -= 1
		cameras[args["number"]].camera.set_meta("visual", true)
		_refresh()
