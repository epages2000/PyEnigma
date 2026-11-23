extends Node2D

@export var limites_inicial: ReferenceRect

func _ready() -> void:
	var cam := $Cantuna/Camera2D as Camera2D
	if limites_inicial and cam:
		CamaraUtil.aplicar(cam, limites_inicial)
