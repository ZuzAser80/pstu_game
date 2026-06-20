class_name FreeroamController extends CharacterBody3D

@export var speed := 5.0
@export var acceleration := 10.0

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera : Camera3D = $FreeroamCam;

static var shotgun_sheels : int = 0
static var cam_repair_kit : int = 1
static var radio : int = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var target_vel := direction * speed
	velocity.x = move_toward(velocity.x, target_vel.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_vel.z, acceleration * delta)

	move_and_slide()
