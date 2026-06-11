extends Node

class_name State;

const IDLE = "IdleState"
const ATTACK = "AttackState"
const ADVANCE = "AdvanceState"
const CHASE = "ChaseState"
const RETREAT = "RetreatState"

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
