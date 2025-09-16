extends CharacterBody2D

const MASS = 10
const GRAVITY = 98
const FRICTION = 100 * MASS
const WEIGHT = MASS * GRAVITY
const MAX_SPEED = 5500
const MOVE_THRUST = 4000 * MASS
const JUMP_THRUST = 1100 * MASS
const JUMP_ACCELERATION_FACTOR = 0.2 # How much your move thrust is affected when jumping


func _process(delta: float) -> void:
	move(delta)
	apply_physics(delta)
	move_and_slide()

func move(delta: float) -> void:
	if Input.is_action_pressed("Jump"):
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y -= JUMP_THRUST * delta
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			velocity.x = move_toward(velocity.x, Input.get_axis("Left", "Right") * MAX_SPEED * delta, MOVE_THRUST * JUMP_ACCELERATION_FACTOR * delta)
	else:
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			velocity.x = move_toward(velocity.x, Input.get_axis("Left", "Right") * MAX_SPEED * delta, MOVE_THRUST * delta)
	
	
func apply_physics(delta: float) -> void:
	if is_on_floor():
		# friction
		if velocity.x != 0:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			
	else:
		# weight
		velocity.y += WEIGHT * delta
	
	
	pass
	
