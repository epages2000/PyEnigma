extends StaticBody2D

signal puerta_abierta
signal puerta_cerrada

@export var textura_abierta: Texture2D
@export var segundos_abierta := 3.0
@export var espera_apertura := 0.12
@export var duracion_fade := 0.12
@export var fade: ColorRect

@export var escena_destino: String = "res://level_1.tscn"
@export var marker_destino: String = "spawn_marker_name"

@onready var sprite: Sprite2D = $Sprite2D
@onready var zona: Area2D = $ZonaInteraccion

var textura_cerrada: Texture2D
var jugador: Node2D
var jugador_cerca := false
var abierta := false
var entro_por_puerta = false

func _ready() -> void:
	textura_cerrada = sprite.texture
	zona.body_entered.connect(_on_body_entered)
	zona.body_exited.connect(_on_body_exited)
	
	# 2. Al regresar a la casa, el fade empieza encendido (1.0) y la alfombra lo apaga (0.0)
	if get_tree().root.has_meta("spawn_marker_name"):
		entro_por_puerta = true
	
	if entro_por_puerta and fade:
		fade.modulate.a = 1.0
		var t_in := create_tween()
		t_in.tween_property(fade, "modulate:a", 0.0, duracion_fade)
		await t_in.finished

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

	if jugador:
		await get_tree().create_timer(espera_apertura).timeout
		await _transportar()
		return
	else:
		await get_tree().create_timer(segundos_abierta).timeout
	cerrar()

func _transportar() -> void:
	# Al salir de la casa, enciende el fade y lo deja visible (1.0)
	if fade:
		fade.modulate.a = 0.0
		var t := create_tween()
		t.tween_property(fade, "modulate:a", 1.0, duracion_fade)
		await t.finished

	if marker_destino != "":
		get_tree().root.set_meta("spawn_marker_name", marker_destino)

	get_tree().change_scene_to_file(escena_destino)

func cerrar() -> void:
	sprite.texture = textura_cerrada
	abierta = false
	puerta_cerrada.emit()
