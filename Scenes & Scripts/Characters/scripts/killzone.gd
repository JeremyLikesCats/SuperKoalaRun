extends Area2D

@onready var timer: Timer = $Timer

var knockback_direction = 1
@export var damage = 1
@export var knockback = true

func _on_body_entered(body: Node2D) -> void:
	if timer.is_stopped() and body.is_in_group("Player"):
		PlayerGlobals.health -= damage
		# Knockback
		if knockback:
			body.knockback(150 * knockback_direction, -100)
		# Start invincibility timer
		timer.start()
