extends Node

signal on_interact;

func _on_interact() -> void:
	on_interact.emit();
