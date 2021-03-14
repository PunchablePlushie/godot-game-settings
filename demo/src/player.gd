extends Sprite

const SPEED: int = 100

onready var viewport: Viewport = get_tree().root
onready var menu_scene: PackedScene = preload("res://demo/src/SettingMenu.tscn")
onready var gui_layer: CanvasLayer = get_node("../GuiLayer")


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		position.x += SPEED*delta
		# warning-ignore:integer_division
		rotate(-SPEED/2)
	
	if Input.is_action_pressed("move_left"):
		position.x -= SPEED*delta
		# warning-ignore:integer_division
		rotate(SPEED/2)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		var menu: Control = menu_scene.instance()
		gui_layer.add_child(menu)
		menu.connect("tree_exited", self, "_on_menu_closed", [], CONNECT_ONESHOT)


func _on_menu_closed() -> void:
	get_tree().paused = false
