extends CharacterBody3D

class_name AI_Base

@export var hostility_level : int;
@export var aggravation : int;
@export var movement_speed : float;
@export var movement_aggravation_multiplier : float = 1;

@export var current_room : Room;
@export var detection_radius : float;
@export var detection_timer_wait : int;
@export var anim : AnimationPlayer;
@export var anim_idle : String = "idle";
@export var anim_walk : String = "walking";
@export var anim_run : String = "run";

@onready var idle_timer : Timer = $IdleTimer;
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D;
@onready var state_machine : StateMachine = $NavigationAgent3D/StateMachine;
@onready var detection_area : Area3D = $DetectionArea;

var target_room : Room;
var target_player : FreeroamController;
var physics_delta : float;
var should_move : bool = false;
var retreating : bool = false;
var target_breakable : Breakable;

var reserved_spot : Node3D;
var reserved_room : Room;

signal on_reached_target;

func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	_reserve_initial_spot()

func _reserve_initial_spot() -> void:
	if current_room == null: return
	var spot = current_room.get_available_spot()
	if spot != null:
		current_room.reserve_spot(spot)
		reserved_spot = spot
		reserved_room = current_room

func _release_current_spot() -> void:
	if reserved_spot != null and reserved_room != null:
		reserved_room.release_spot(reserved_spot)
	reserved_spot = null
	reserved_room = null

func _reserve_spot_in(target: Room) -> Node3D:
	var spot = target.get_available_spot()
	if spot != null:
		target.reserve_spot(spot)
		reserved_spot = spot
		reserved_room = target
	return spot

func _move_to_target_room() -> bool:
	if target_room == null: return false
	_release_current_spot()
	var spot = _reserve_spot_in(target_room)
	if spot == null:
		print("No available spots in:", target_room.name)
		return false
	print("Moving from:", current_room.name, "to:", target_room.name)
	nav_agent.target_position = spot.global_position;
	print(nav_agent.target_position)
	if not nav_agent.target_reached.is_connected(_on_move_completion):
		nav_agent.target_reached.connect(_on_move_completion);
	return true

func _on_move_completion() -> void:
	should_move = false;
	current_room = target_room;
	nav_agent.target_reached.disconnect(_on_move_completion)
	on_reached_target.emit();	

func _face_direction(delta: float) -> void:
	var next_pos = nav_agent.get_next_path_position()
	var dir = global_position.direction_to(next_pos)
	dir.y = 0
	if dir.length() > 0.01:
		global_basis = global_basis.slerp(Basis.looking_at(dir, Vector3.UP, true), delta * 8.0)

func _physics_process(delta: float) -> void:
	if not should_move: return
	physics_delta = delta
	_face_direction(delta)
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed * (0.2 * hostility_level)
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		velocity = new_velocity
	move_and_slide()

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity

func trigger_flee() -> void:
	state_machine._transition_to_state(State.FLEE)

func respawn_at_farthest_room() -> void:
	var rooms = GameModeManager.instance.all_rooms
	if rooms.is_empty():
		return
	var max_dist = 0
	for r in rooms:
		if r.distance_to_office > max_dist:
			max_dist = r.distance_to_office
	var candidates = rooms.filter(func(r: Room): return r.distance_to_office == max_dist)
	candidates.shuffle()
	for target in candidates:
		var spot = target.get_available_spot()
		if spot != null:
			_release_current_spot()
			global_position = spot.global_position
			target.reserve_spot(spot)
			reserved_spot = spot
			reserved_room = target
			current_room = target
			should_move = false
			if nav_agent.target_reached.is_connected(_on_move_completion):
				nav_agent.target_reached.disconnect(_on_move_completion)
			nav_agent.target_position = spot.global_position
			return
