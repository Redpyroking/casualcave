extends KinematicBody2D
class_name Player

enum { MOVE, CLIMB }

const JUMP_FORCE = -160
const JUMP_RELEASE_FORCE = -70
const MAX_SPEED = 75
const ACC = 600
const FRICTION = 600
const GRAVITY = 300
const ADDITIONAL_FALL_GRAVITY = 120
const CLIMB_SPEED = 50
const DOUBLE_JUMP_COUNT = 1

var velocity = Vector2.ZERO
var state = MOVE
var double_jump = 1
var buffered_jump = false
var coyote_jump = false
var on_door = false

onready var animatedSprite: = $Sprite
onready var jumpBufferTimer: = $BufferJump
onready var coyoteJumpTimer: = $Coyote

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: move_state(input, delta)
		CLIMB: climb_state(input)

func move_state(input, delta):
#	if is_on_ladder() and Input.is_action_just_pressed("ui_up"):
#		state = CLIMB
	
	apply_gravity(delta)
	
	if not horizontal_move(input):
		apply_friction(delta)
#		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x, delta)
#		animatedSprite.animation = "Run"
		animatedSprite.flip_h = input.x < 0
	
	if is_on_floor():
		reset_double_jump()
	else:
#		animatedSprite.animation = "Jump"
		pass
	
	if can_jump():
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		fast_fall(delta)
	
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		pass
#		animatedSprite.animation = "Run"
#		animatedSprite.frame = 1
	
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()
	attack()

func attack():
	if Input.is_action_just_pressed("attack") and !$weapon/AnimationPlayer.is_playing():
		$weapon/AnimationPlayer.play("swing")

func climb_state(input):
#	if not is_on_ladder(): state = MOVE
	if input.length() != 0:
#		animatedSprite.animation = "Run"
		pass
	else:
		pass
#		animatedSprite.animation = "Idle"
	velocity = input * CLIMB_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)

func player_die():
	queue_free()

func input_jump_release():
	if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
		velocity.y = JUMP_RELEASE_FORCE

func input_double_jump():
	if Input.is_action_just_pressed("ui_up") and double_jump > 0:
		velocity.y = JUMP_FORCE
		double_jump -= 1

func buffer_jump():
	if Input.is_action_just_pressed("ui_up"):
		buffered_jump = true
		jumpBufferTimer.start()

func fast_fall(delta):
	if velocity.y > 0:
		velocity.y += ADDITIONAL_FALL_GRAVITY * delta

func can_jump():
	return is_on_floor() or coyote_jump

func horizontal_move(input):
	return input.x != 0

func reset_double_jump():
	double_jump = DOUBLE_JUMP_COUNT

func input_jump():
	if on_door: return
	if Input.is_action_just_pressed("ui_up") or buffered_jump:
		velocity.y = JUMP_FORCE
		buffered_jump = false

#func is_on_ladder():
#	if not ladderCheck.is_colliding(): return false
#	var collider = ladderCheck.get_collider()
#	if not collider is Ladder: return false
#	return true

func apply_gravity(delta):
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, 300)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0,FRICTION * delta)

func apply_acceleration(amount, delta):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACC * delta)

func _on_BufferJump_timeout():
	buffered_jump = false
	pass # Replace with function body.

func _on_Coyote_timeout():
	coyote_jump = false
	pass # Replace with function body.
