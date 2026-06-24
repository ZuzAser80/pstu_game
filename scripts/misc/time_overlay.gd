class_name TimeOverlay extends Node3D

@onready var viewport: SubViewport = $OverlayViewport
@onready var sprite: Sprite3D = $TimeSprite

func _ready() -> void:
	sprite.texture = viewport.get_texture()
