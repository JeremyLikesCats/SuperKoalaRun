extends Area2D

@onready var timer: Timer = $Timer

var knockback_direction = 1
@export var damage = 1
@export var knockback = true
@export var instakill = false

func _on_body_entered(body: Node2D) -> void:
	if instakill:
		if body.is_in_group("Player"):
			body.die()
	else:
		if body.is_in_group("Player") and body.get_node("InvincibilityTimer").is_stopped():
			body.damage(damage)
			# Knockback
			if knockback:
				body.knockback(150 * knockback_direction, -100)
