class_name CamaraUtil

static func aplicar(cam: Camera2D, r: ReferenceRect) -> void:
	var vista := cam.get_viewport_rect().size / cam.zoom
	var izq := r.global_position.x
	var der := izq + r.size.x
	var arr := r.global_position.y
	var aba := arr + r.size.y

	if r.size.x < vista.x:
		var extra_x := (vista.x - r.size.x) / 2.0
		izq -= extra_x
		der += extra_x
	if r.size.y < vista.y:
		var extra_y := (vista.y - r.size.y) / 2.0
		arr -= extra_y
		aba += extra_y

	cam.limit_left = int(izq)
	cam.limit_right = int(der)
	cam.limit_top = int(arr)
	cam.limit_bottom = int(aba)

static func aplicar_en(cam: Camera2D, punto: Vector2) -> void:
	for n in cam.get_tree().get_nodes_in_group("limites_sala"):
		var r := n as ReferenceRect
		if r and Rect2(r.global_position, r.size).has_point(punto):
			aplicar(cam, r)
			return
