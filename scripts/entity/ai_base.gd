extends Node

class_name AI_Base

@export var hostility_level : int;
@export var aggravation : int;
@export var movement_speed : float;

@export var current_room : Room;
@export var detection_radius : float;
@export var anim : AnimationPlayer;

@onready var idle_timer : Timer = get_node("IdleTimer");
@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D");

var target_room : Room;
var physics_delta : float;
var should_move : bool = false;

signal on_reached_target;

func _ready() -> void:
	#state_machine.ai_base
	pass # Replace with function body.
	#state_machine._transition_to_state();

func _move_to_target_room() -> void:
	print("Moving from:", current_room.name, "to:", target_room.name)
	nav_agent.target_position = target_room.spots.pick_random().global_position;
	nav_agent.target_reached.connect(_on_move_completion);

func _on_move_completion() -> void:
	should_move = false;
	on_reached_target.emit();	

func _physics_process(delta: float) -> void:
	if not should_move: return
	physics_delta = delta;
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = nav_agent.global_position.direction_to(next_path_position) * movement_speed * (0.2 * hostility_level);
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	nav_agent.global_position = nav_agent.global_position.move_toward(nav_agent.global_position + safe_velocity, physics_delta * movement_speed)
