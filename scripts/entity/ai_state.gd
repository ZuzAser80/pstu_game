extends Node

class_name State;

static var IDLE = "IdleState"
static var ATTACK = "AttackState"
static var ADVANCE = "AdvanceState"
static var CHASE = "ChaseState"
static var INVESTIGATE = "InvestigateState"
static var FLEE = "FleeState"

var state_name := "";

var ai_base : AI_Base;

# Called when the node enters the scene tree for the first time.
signal transitioned(string : String)

func enter(_char_reference : AI_Base):
	#enter state
	ai_base = _char_reference;
	pass
	
func exit():
	#exit state
	pass
	
func update(_delta : float):
	#process update
	pass
	
func physics_update(_delta : float):
	#physics_process update
	pass 
