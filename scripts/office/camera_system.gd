class_name CameraSystem extends Node

#@export var rooms : Array[Room]
@export var cameras : Array[SubViewport];
@export var cam_to_room : Dictionary[SubViewport, Room]
@export var no_visual : Texture2D
@export var display : Sprite3D
@export var close_up : Sprite2D

var close_up_open := false
var currentIndex := 0;

func _ready() -> void:
	pass;

func _refresh() -> void:
	if cameras[currentIndex].get_meta("visual"):
		var viewport_texture = cameras[currentIndex].get_texture();
		close_up.texture = viewport_texture;	
		display.texture = viewport_texture;
	else:
		close_up.texture = no_visual;
		display.texture = no_visual;

func radio_active() -> bool:
	return cam_to_room.has(cameras[currentIndex])

func trigger_radio(number: Dictionary[String, Variant]) -> void:	
	print("triggering radio")
	if radio_active():
		cam_to_room[cameras[currentIndex]].distraction.activate()
	else:
		print("haven't found proper meta")
		

func move_to_cam(index: int) -> void:	
	currentIndex = index;
	OfficeUIController.on_camera_switched(radio_active())
	_refresh();

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		close_up_open =  false;
		close_up.texture = null;

func trigger_cam(number: Dictionary[String, Variant]) -> void:
	close_up_open = true;
	move_to_cam(number["number"] as int);

func repair_cam(args: Dictionary[String, Variant]) -> void:
	#print("nigga")
	if args.has("number") and GameModeManager.cam_repair_kit > 0:
		#print("nigga22")
		GameModeManager.cam_repair_kit -= 1
		cameras[args["number"]].set_meta("visual", true)
		_refresh()
