extends CharacterBody3D

class_name AI_Base

@export var hostility_level : int;
@export var aggravation : int;
@export var movement_speed : float;
@export var movement_aggravation_multiplier : float = 1;

@export var current_room : Room;
@export var detection_radius : float;
@export var anim : AnimationPlayer;

@onready var idle_timer : Timer = $IdleTimer;
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D;

var target_room : Room;
var physics_delta : float;
var should_move : bool = false;
var retreating : bool = false;
var target_breakable : Breakable;

signal on_reached_target;

func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_velocity_computed)

func _move_to_target_room() -> void:
	if target_room == null: return
	print("Moving from:", current_room.name, "to:", target_room.name)
	nav_agent.target_position = target_room.spots.pick_random().global_position;
	print(nav_agent.target_position)
	if not nav_agent.target_reached.is_connected(_on_move_completion):
		nav_agent.target_reached.connect(_on_move_completion);

func _on_move_completion() -> void:
	should_move = false;
	current_room = target_room;
	nav_agent.target_reached.disconnect(_on_move_completion)
	on_reached_target.emit();	

func _physics_process(delta: float) -> void:
	if not should_move: return
	physics_delta = delta
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed * (0.2 * hostility_level)
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		velocity = new_velocity
	move_and_slide()

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
