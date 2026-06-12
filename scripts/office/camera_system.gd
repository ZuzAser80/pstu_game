extends Node

@export var cameras : Array[SubViewport];
@export var no_visual : Texture2D
@export var display : Sprite3D
@export var close_up : Sprite2D

var close_up_open := false
var currentIndex := 0;

func _ready() -> void:
	pass;

func _refresh() -> void:
	if cameras[currentIndex].get_meta("visual", false):
		var viewport_texture = cameras[currentIndex].get_texture();
		close_up.texture = viewport_texture;	
		display.texture = viewport_texture;
	else:
		close_up.texture = no_visual;
		display.texture = no_visual;
	

func _move_to_cam(index: int) -> void:
	currentIndex = index;
	_refresh();

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		close_up_open =  false;
		close_up.texture = null;

func _on_player_cam_clicked_closeup(number: Variant) -> void:	
	close_up_open = true;
	_move_to_cam(number);
