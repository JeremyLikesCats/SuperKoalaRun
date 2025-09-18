extends Node2D

const SPEED = 60

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_weak_spots = $RayCastWeakSpots.get_children()

@onready var timer: Timer = $Killzone/Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const MIN_FALLING_VEL = -10

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
	
	for ray_cast_weak_spot in ray_cast_weak_spots:
		if ray_cast_weak_spot.is_colliding():
			var collider = ray_cast_weak_spot.get_collider()
			print("hsswejfi")
			if collider != null and collider.is_in_group("Player") and collider.jumping == false:
				print("hsswejfi")
				collider.knockback(collider.velocity.x, -150)
				die()
			$Killzone.knockback_direction = 1
		
	position.x += SPEED * direction * delta
	
func die():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y + 300), 1)
	tween.finished.connect(on_death_anim_finished)

func on_death_anim_finished():
	queue_free()
