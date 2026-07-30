class_name StateMachine extends Node

@onready var current_state : State = get_node("IdleState");
@export var ai_base : AI_Base;

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
		return	

	current_state.exit();

	var new_state = get_node(newState);

	new_state.enter(ai_base);
	current_state = new_state;
