extends Node

signal on_interact(args: Dictionary)

func interact(args: Dictionary[String, Variant]) -> void:
	on_interact.emit(args)
