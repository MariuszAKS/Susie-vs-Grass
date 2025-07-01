extends Node2D


@onready var susie_animations = get_node("Animations") as AnimatedSprite2D
@onready var coin_animations = get_node("AnimationPlayer") as AnimationPlayer

@export var destinations: Array[Marker2D]
var next_destination = -1

var is_walking = false
var direction = Vector2.RIGHT
var speed = 80

var distance_to_destination

@export var label_points: Label
var points = 0


func _ready():
	coin_animations.animation_finished.connect(on_grass_picked)
	start_walking()


func start_walking():
	next_destination += 1
	if next_destination >= destinations.size():
		next_destination = 0

	direction = (destinations[next_destination].global_position - global_position).normalized()

	match direction:
		Vector2.DOWN: susie_animations.play("walk_down")
		Vector2.LEFT: susie_animations.play("walk_left")
		Vector2.RIGHT: susie_animations.play("walk_right")
		Vector2.UP: susie_animations.play("walk_up")
		_: susie_animations.play("idle")

	is_walking = true


func on_grass_picked(_animation_name):
	points += 5
	label_points.text = str(points)

	start_walking()


func _process(delta):
	if is_walking:
		global_position += direction * speed * delta
		distance_to_destination = (destinations[next_destination].global_position - global_position).length()

		print(global_position)
	
		if distance_to_destination < 4:
			global_position = destinations[next_destination].global_position
			is_walking = false

			coin_animations.play("coin")
