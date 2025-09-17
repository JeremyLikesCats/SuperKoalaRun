extends CharacterBody2D

const MASS = 10
const GRAVITY = 75
const FRICTION = 100 * MASS
const WEIGHT = MASS * GRAVITY
const MAX_SPEED = 6000
const MAX_JUMP_HEIGHT = 25
const MOVE_THRUST = 1500 * MASS
const JUMP_SPEED = 13 * MASS
const HOLD_JUMP_SPEED = 16 * MASS
const JUMP_ACCELERATION_FACTOR = 0.05 # How much your move thrust is affected when jumping

var jumping = false
var jump_height = 0

func _process(delta: float) -> void:
	move(delta)
	apply_physics(delta)
	jump_calculations(delta)
	move_and_slide()

func jump_calculations(delta: float) -> void:
	jump_height += -velocity.y * delta
	print(jump_height)
	if jump_height > MAX_JUMP_HEIGHT or is_on_floor() and velocity.y == 0:
		jumping = false
		jump_height = 0

func move(delta: float) -> void:
	if is_on_floor():
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			rotation += 0.1 * Input.get_axis("Left", "Right")
			velocity.x = move_toward(velocity.x, Input.get_axis("Left", "Right") * MAX_SPEED * delta, MOVE_THRUST * delta)
		velocity.y = 0
		if Input.is_action_just_pressed("Jump"):
			jumping = true
			velocity.y = -JUMP_SPEED 
		
	else:
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			rotation += 0.08 * Input.get_axis("Left", "Right")
			velocity.x = move_toward(velocity.x, Input.get_axis("Left", "Right") * MAX_SPEED * delta, MOVE_THRUST * delta * JUMP_ACCELERATION_FACTOR)
		if Input.is_action_pressed("Jump") and jumping:
			print("hi")
			velocity.y = -HOLD_JUMP_SPEED
		if not Input.is_action_pressed("Jump"):
			jumping = false
		
	
	
func apply_physics(delta: float) -> void:
	if is_on_floor():
		# friction
		if velocity.x != 0:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			
	else:
		# weight
		velocity.y += WEIGHT * delta
	
	
	pass
	
