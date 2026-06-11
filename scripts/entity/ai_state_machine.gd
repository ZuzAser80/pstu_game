class_name StateMachine extends Node

@export var initial_state : State = null;
#@export var states : Array[State];

@onready var current_state : State = get_node("IdleState");
@export var ai_base : AI_Base;

var last_state;

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.transitioned.connect(_transition_to_state)

	await owner.ready
	current_state.enter(ai_base);

func _process(delta: float) -> void:
	current_state.update(delta);

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func _transition_to_state(newState : String) -> void:
	if not has_node(newState):
		print("err, wrong transition path:", newState)
		return	

	current_state.exit();
	last_state = current_state;

	var new_state = get_node(newState);

	new_state.enter(ai_base);
	current_state = new_state;
