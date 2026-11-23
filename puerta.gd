extends StaticBody2D

signal puerta_abierta
signal puerta_cerrada

@export var limites_destino: ReferenceRect
@export var textura_abierta: Texture2D
@export var segundos_abierta := 3.0
@export var espera_apertura := 0.12
@export var duracion_fade := 0.12
@export var destino: Marker2D
@export var fade: ColorRect

@onready var sprite: Sprite2D = $Sprite2D
@onready var zona: Area2D = $ZonaInteraccion

var textura_cerrada: Texture2D
var jugador: Node2D
var jugador_cerca := false
var abierta := false

func _ready() -> void:
	textura_cerrada = sprite.texture
	zona.body_entered.connect(_on_body_entered)
	zona.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false

func _process(_delta: float) -> void:
	if jugador_cerca and not abierta and Input.is_action_pressed("ui_up"):
		abrir()

func abrir() -> void:
	abierta = true
	if textura_abierta:
		sprite.texture = textura_abierta
	puerta_abierta.emit()

	if destino and jugador:
		await get_tree().create_timer(espera_apertura).timeout
		await _transportar()
	else:
		await get_tree().create_timer(segundos_abierta).timeout
	cerrar()

func _transportar() -> void:
	if fade:
		var t := create_tween()
		t.tween_property(fade, "modulate:a", 1.0, duracion_fade)
		await t.finished

	jugador.global_position = destino.global_position
	var cam := jugador.get_node_or_null("Camera2D") as Camera2D
	if cam:
		if limites_destino:
			CamaraUtil.aplicar(cam, limites_destino)
		cam.reset_smoothing()

	if fade:
		var t2 := create_tween()
		t2.tween_property(fade, "modulate:a", 0.0, duracion_fade)
		await t2.finished

func cerrar() -> void:
	sprite.texture = textura_cerrada
	abierta = false
	puerta_cerrada.emit()
