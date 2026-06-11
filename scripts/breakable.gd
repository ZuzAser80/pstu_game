class_name Breakable extends Node

enum BreakableType { Camera, Radio };

@export var type : BreakableType;

signal on_broken

func _break() -> void:
	match type:
		BreakableType.Camera:
			if get_meta("visual"):
				set_meta("visual", false);
			else:
				set_meta("audio", false);	
		BreakableType.Radio:
			set_meta("radius", get_meta("radius") * 0.8);
	on_broken.emit()
