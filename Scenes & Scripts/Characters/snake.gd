extends Node2D

const SPEED = 60

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		var collider = ray_cast_right.get_collider()
		if collider != null and not collider.is_in_group("Player"):
			direction = -1
			animated_sprite_2d.flip_h = true
		$Killzone.knockback_direction = 1
		
	if ray_cast_left.is_colliding():
		var collider = ray_cast_left.get_collider()
		if collider != null and not collider.is_in_group("Player"):
			direction = 1
			animated_sprite_2d.flip_h = false
		$Killzone.knockback_direction = -1
		
	position.x += SPEED * direction * delta
