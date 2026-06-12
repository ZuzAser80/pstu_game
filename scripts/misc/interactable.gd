extends Node

signal on_interact;

func interact() -> void:
	on_interact.emit();
