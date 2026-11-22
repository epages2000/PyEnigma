extends Sprite2D

@export var destino: Marker2D
@export var fade: ColorRect
@export var duracion_fade := 0.12

var jugador: Node2D
var jugador_encima := false
var usando := false

func _ready() -> void:
	var area := Area2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	var tam := texture.get_size()
	rect.size = tam
	shape.shape = rect
	shape.position = offset
	if not centered:
		shape.position += tam / 2.0
	area.add_child(shape)
	add_child(area)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body
		jugador_encima = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_encima = false

func _process(_delta: float) -> void:
	if jugador_encima and not usando and destino and Input.is_action_pressed("ui_down"):
		_transportar()

func _transportar() -> void:
	usando = true

	if fade:
		var t := create_tween()
		t.tween_property(fade, "modulate:a", 1.0, duracion_fade)
		await t.finished

	jugador.global_position = destino.global_position
	var cam := jugador.get_node_or_null("Camera2D") as Camera2D
	if cam:
		cam.reset_smoothing()

	if fade:
		var t2 := create_tween()
		t2.tween_property(fade, "modulate:a", 0.0, duracion_fade)
		await t2.finished

	usando = false
