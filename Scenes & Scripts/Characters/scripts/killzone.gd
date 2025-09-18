extends Area2D

@onready var timer: Timer = $Timer

var knockback_direction = 1
@export var damage = 1

func _on_body_entered(body: Node2D) -> void:
	if timer.is_stopped() and body.is_in_group("Player"):
		# When attacked
		
		# Deduct health
		if PlayerGlobals.health > 1:
			PlayerGlobals.health -= damage
			Stats.health_change()
		else:
			print("You died")
			PlayerGlobals.health = PlayerGlobals.MAX_HEALTH
			get_tree().reload_current_scene()
		print(knockback_direction)
		# Knockback
		body.knockback(150 * knockback_direction, -100)
		
		# Start invincibility timer
		timer.start()
		
