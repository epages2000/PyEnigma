extends CharacterBody2D

const BASE := "res://cantuna"
const SPEED := 200.0
const DIRS := ["down", "up", "left_down", "left_up", "right_down", "right_up"]

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var facing := "down"

func _ready() -> void:
	sprite.sprite_frames = _build_frames()
	sprite.offset = Vector2(0, 0)  # los pies quedan en el origen del nodo
	sprite.play("idle_down")

func _build_frames() -> SpriteFrames:
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	for kind in ["Idle", "Walk"]:
		for d in DIRS:
			var tex: Texture2D = load("%s/%s/%s_%s.png" % [BASE, kind, kind.to_lower(), d])
			var anim := "%s_%s" % [kind.to_lower(), d]
			sf.add_animation(anim)
			sf.set_animation_speed(anim, 8)
			sf.set_animation_loop(anim, true)
			for i in 8:
				var at := AtlasTexture.new()
				at.atlas = tex
				at.region = Rect2(i * 48, 0, 48, 64)
				sf.add_frame(anim, at)
	return sf

func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input * SPEED
	move_and_slide()

	if input != Vector2.ZERO:
		facing = _dir_name(input)
		sprite.play("walk_" + facing)
	else:
		sprite.play("idle_" + facing)

func _dir_name(v: Vector2) -> String:
	var h := "left" if v.x < -0.3 else ("right" if v.x > 0.3 else "")
	var vert := "up" if v.y < -0.3 else ("down" if v.y > 0.3 else "")
	if h == "":
		return vert
	if vert == "":
		return h + "_down"  # el pack no trae izquierda/derecha puras
	return h + "_" + vert
