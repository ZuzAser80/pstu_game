extends Node

class_name AI_Base

@export var hostility_level : int;
@export var starting_locations : Array[Room];
@export var current_room : Room;
@export var detection_radius : float;
@export var anim : AnimationPlayer;

@onready var idle_timer : Timer = get_node("IdleTimer");
@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#state_machine.ai_base
	pass # Replace with function body.
	#state_machine._transition_to_state();



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
