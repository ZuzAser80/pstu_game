class_name MainMenu extends Node3D

@onready var pivot: Node3D = $CameraPivot

func _ready() -> void:
	$CameraPivot/MenuCamera.look_at(Vector3(0, 1, 0))

func _process(delta: float) -> void:
	pivot.rotation.y += delta * 0.15

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_start_game()

func _on_play_pressed() -> void:
	_start_game()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
