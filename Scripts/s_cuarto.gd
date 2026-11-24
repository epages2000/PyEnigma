extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var entered = false

func _on_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_body_exited(body) -> void:
	entered = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			print("Hello") # CAMBIAR POR ALGO SIGNIFICATIVO CUANDO PONGA ENTER
	pass
