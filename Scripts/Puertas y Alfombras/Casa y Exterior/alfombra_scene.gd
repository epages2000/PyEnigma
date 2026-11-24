extends Sprite2D

@export var fade: ColorRect
@export var duracion_fade := 0.12

@export var next_scene_path: String = "res://exterior.tscn"
@export var return_marker_name: String = "spawn_marker_name"

var jugador: Node2D
var jugador_encima := false
var usando := false

func _ready() -> void:
	var entro_por_puerta := false

	# 1. Si regresa desde exterior, ubica al jugador y resetea la cámara
	if get_tree().root.has_meta("spawn_marker_name"):
		entro_por_puerta = true
		var target_name: String = str(get_tree().root.get_meta("spawn_marker_name"))
		var root_node := owner if owner else get_parent()
		var marker := root_node.find_child(target_name, true, false) as Node2D
		var player := get_tree().get_first_node_in_group("jugador") as Node2D
		if marker and player:
			player.global_position = marker.global_position
			var cam := player.find_child("Camera2D", true, false) as Camera2D
			if cam:
				cam.reset_smoothing()
			get_tree().root.remove_meta("spawn_marker_name")

	# 2. Al regresar a la casa, el fade empieza encendido (1.0) y la alfombra lo apaga (0.0)
	if entro_por_puerta and fade:
		fade.modulate.a = 1.0
		var t_in := create_tween()
		t_in.tween_property(fade, "modulate:a", 0.0, duracion_fade)
		await t_in.finished

	# 3. Area 2D
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
	if jugador_encima and not usando and Input.is_action_pressed("ui_down"):
		_transportar()

func _transportar() -> void:
	usando = true

	# Al salir de la casa, enciende el fade y lo deja visible (1.0)
	if fade:
		fade.modulate.a = 0.0
		var t := create_tween()
		t.tween_property(fade, "modulate:a", 1.0, duracion_fade)
		await t.finished

	if return_marker_name != "":
		get_tree().root.set_meta("spawn_marker_name", return_marker_name)

	get_tree().change_scene_to_file(next_scene_path)
