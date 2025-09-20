extends CharacterBody2D

const MASS = 10
const GRAVITY = 80
const FRICTION = 100 * MASS
const WEIGHT = MASS * GRAVITY
const MAX_SPEED = 7000
const MAX_JUMP_HEIGHT = 25
const MOVE_THRUST = 1500 * MASS
const JUMP_SPEED = 13 * MASS
const HOLD_JUMP_SPEED = 16 * MASS
const JUMP_ACCELERATION_FACTOR = 0.05 # How much your move thrust is affected when jumping

const KNOCKBACK_GRAVITY = WEIGHT * 0.05

var jumping = false
var jump_height = 0

var knockedback = false
var knockback_x = 0
var knockback_y = 0


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var knockback_timer: Timer = $KnockbackTimer

func _process(delta: float) -> void:
	
	move(delta)
	knockback_detection(delta)
	
	jump_calculations(delta)
	apply_physics(delta)
	move_and_slide()

	check_died()

func check_died() -> void:
	if PlayerGlobals.health < 0:
		get_tree().reload_current_scene()
		PlayerGlobals.health = 5

func jump_calculations(delta: float) -> void:
	jump_height += -velocity.y * delta
	if jump_height > MAX_JUMP_HEIGHT or is_on_floor() and velocity.y == 0:
		jumping = false
		jump_height = 0

func move(delta: float) -> void:
	if is_on_floor():
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			animated_sprite_2d.flip_h = Input.get_axis("Left", "Right")
			# rotation += 0.1 * Input.get_axis("Left", "Right")
			velocity.x = move_toward(velocity.x, Input.get_axis("Left", "Right") * MAX_SPEED * delta, MOVE_THRUST * delta)
		velocity.y = 0
		if Input.is_action_just_pressed("Jump"):
			jumping = true
			velocity.y = -JUMP_SPEED 
		
	else:
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			animated_sprite_2d.flip_h = Input.get_axis("Left", "Right")
			# rotation += 0.08 * Input.get_axis("Left", "Right")
			velocity.x = move_toward(velocity.x, Input.get_axis("Left", "Right") * MAX_SPEED * delta, MOVE_THRUST * delta * JUMP_ACCELERATION_FACTOR)
		if Input.is_action_pressed("Jump") and jumping:
			velocity.y = -HOLD_JUMP_SPEED
		if not Input.is_action_pressed("Jump"):
			jumping = false
		
func knockback_detection(delta: float) -> void:
	if not knockback_timer.is_stopped():
		velocity.x = knockback_x
		velocity.y = knockback_y
		
		# Add extra gravity
		velocity.y += KNOCKBACK_GRAVITY
	
func apply_physics(delta: float) -> void:
	if is_on_floor():
		# friction
		if velocity.x != 0:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	else:
		
		# weight
		velocity.y += WEIGHT * delta

func knockback(magnitude_x = null, magnitude_y = null) -> void:
	knockback_x = magnitude_x
	knockback_y = magnitude_y
	if knockback_x == null:
		knockback_x = velocity.x
	if knockback_y == null:
		knockback_y = velocity.y
	$KnockbackTimer.start()
	
