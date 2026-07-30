class_name FreeroamUIManager extends Node

@export var notebook_background : Node
@export var shotgun_shells_label : Label
@export var cam_repair_label : Label
@export var radio_label : Label
@export var crosshair : TextureRect

func refresh_inventory(shells: int, kits: int, radios: int) -> void:
	if shotgun_shells_label:
		shotgun_shells_label.text = "x%d" % shells
	if cam_repair_label:
		cam_repair_label.text = "x%d" % kits
	if radio_label:
		radio_label.text = "x%d" % radios

func set_crosshair_visible(visible: bool) -> void:
	if crosshair:
		crosshair.visible = visible
