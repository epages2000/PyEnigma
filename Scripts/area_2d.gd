extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var entered = false
var nueva_escena = "res://begin.tscn" # Escena a la que vas a cambiar

func _on_body_entered(body: PhysicsBody2D) -> void:
	entered = true

func _on_body_exited(body) -> void:
	entered = false

func _physics_process(delta: float) -> void:
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file(nueva_escena)
