extends CharacterBody2D

const SPEED := 85.0
const JUMP_VELOCITY := -250.0
const STOP_DISTANCE := 10.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player: CharacterBody2D
var jump_cooldown := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D

func _physics_process(delta: float) -> void:
	if player == null:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	jump_cooldown -= delta

	var distance_to_player: float = player.global_position.x - global_position.x
	var direction: float = signf(distance_to_player)

	if absf(distance_to_player) > STOP_DISTANCE:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * 8.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * 8.0 * delta)

	var player_is_above: bool = player.global_position.y < global_position.y - 25.0
	var close_enough_to_chase: bool = absf(distance_to_player) < 90.0

	if is_on_floor() and player_is_above and close_enough_to_chase and jump_cooldown <= 0.0:
		velocity.y = JUMP_VELOCITY
		jump_cooldown = 0.8

	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x > 0

	if not is_on_floor():
		animated_sprite.play("jump")
	elif abs(velocity.x) > 5:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	move_and_slide()
