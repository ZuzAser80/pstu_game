class_name InventoryManager extends Node

@export var start_shells : int = 0
@export var start_kits : int = 1
@export var start_radios : int = 0

var shotgun_shells : int = 0
var cam_repair_kit : int = 1
var radio : int = 0
var money : int = 0

func _ready() -> void:
	shotgun_shells = start_shells
	cam_repair_kit = start_kits
	radio = start_radios
