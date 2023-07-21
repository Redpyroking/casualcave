extends "res://baseTemplate/entity.gd"
class_name Player

enum { MOVE, CLIMB }

const MAX_SPEED = 200
const ACC = 700
const FRICTION = 1000

var velocity = Vector2.ZERO
var double_jump = 1
var buffered_jump = false
var coyote_jump = false
var on_door = false

export var active_camera = false
var knockback = 400
var knockup = 300

onready var animatedSprite: = $Sprite
onready var jumpBufferTimer: = $BufferJump
onready var coyoteJumpTimer: = $Coyote
onready var healthBar = $healthBar

func _ready():
	Global.Player = self
	hp = maxHp
	healthBar.max_value = hp
	healthBar.value = hp
	$Camera2D.current = active_camera

func _physics_process(delta):
	healthBar.value = hp
	move_state(delta)

func move_state(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x += MAX_SPEED
		$Sprite.scale.x = -2
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= MAX_SPEED
		$Sprite.scale.x = 2
	else:
		velocity.x = 0
	if Input.is_action_pressed("ui_up"):
		velocity.y -= MAX_SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y += MAX_SPEED
	else:
		velocity.y = 0
	if velocity == Vector2.ZERO:
		$Sprite.play("idle")
	else:
		$Sprite.play("walk")
	velocity = velocity.normalized()
	move_and_slide(velocity* MAX_SPEED,Vector2.UP)

func _input(event):
	if event.is_action_pressed("attack"):
		attack()
		pass

func attack():
	if Input.is_action_just_pressed("attack") and $weaponPos/weapon.weaponRes.holdItem == null:
		#melee attack
		$weaponPos/weapon/AnimationPlayer.play("swing")
		$weaponPos/weapon.attack()
	elif Input.is_action_just_pressed("attack") and !$weaponPos/weapon/AnimationPlayer.is_playing():
		$weaponPos/weapon/AnimationPlayer.play("swing")
		$weaponPos/weapon.attack()

func player_die():
	queue_free()

func knock(distance_bool):
	if !distance_bool:
		velocity.x = lerp(velocity.x,knockback,0.5)
		velocity.y = lerp(velocity.y,-knockup,0.5)
	else:
		velocity.x = lerp(velocity.x,-knockback,0.5)
		velocity.y = lerp(velocity.y,-knockup,0.5)
	velocity = move_and_slide(velocity,Vector2.UP)
	hp -= 6


func _on_Sprite_animation_finished():
	if $Sprite.animation == "attack":
		$Sprite.play("default")
