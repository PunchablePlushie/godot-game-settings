extends CollisionShape2D

enum Side {LEFT, TOP, RIGHT, BOT}

@export var side: Side
@export var harm_scn: PackedScene
@export var scene_root: Node2D


func spawn_harm() -> void:
	var Harm: CharacterBody2D = harm_scn.instantiate()
	match side:
		Side.LEFT:
			Harm.dir = Vector2.RIGHT
			Harm.position.x = position.x
			Harm.position.y = randi_range(0, shape.b.y)
		Side.RIGHT:
			Harm.dir = Vector2.LEFT
			Harm.position.x = position.x
			Harm.position.y = randi_range(0, shape.b.y)
		Side.TOP:
			Harm.dir = Vector2.DOWN
			Harm.position.x = randi_range(0, shape.b.x)
			Harm.position.y = position.y
		Side.BOT:
			Harm.dir = Vector2.UP
			Harm.position.x = randi_range(0, shape.b.x)
			Harm.position.y = position.y
	
	scene_root.add_child(Harm)
