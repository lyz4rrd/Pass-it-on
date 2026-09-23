extends Area2D

@export var holder_offset: Vector2 = Vector2(0, -18)
@export var transfer_cooldown: float = 0.7

var holder: CharacterBody2D
var cooldown_remaining: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if cooldown_remaining > 0.0:
		cooldown_remaining -= delta

func set_holder(new_holder: CharacterBody2D) -> void:
	holder = new_holder
	call_deferred("_attach_to_holder")

func _attach_to_holder() -> void:
	if holder == null:
		return

	reparent(holder)
	position = holder_offset

func _on_body_entered(body: Node2D) -> void:
	if cooldown_remaining > 0.0:
		return

	if body == holder:
		return

	# Only transfer between the monkey and robots.
	if body.is_in_group("player") or body.is_in_group("robot"):
		set_holder(body as CharacterBody2D)
		cooldown_remaining = transfer_cooldown
