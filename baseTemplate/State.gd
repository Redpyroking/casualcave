extends Node

onready var parent = get_parent()
onready var playerDetect = $"../playerDetect"
var playerNear = false

func _ready():
	randomize()

func _physics_process(delta):
	print(parent.motion.y)
	match parent.STATE_MOVE:
		parent.state_movement.IDLE:
			if parent.is_moving:
				change_state(parent.state_movement.MOVE)
		parent.state_movement.MOVE:
			if playerNear:
				change_state(parent.state_movement.CHASE)
			if !parent.get_node("emptyGroundCheck").is_colliding():
				change_state(parent.state_movement.FALL)
			if !parent.get_node("emptyGroundCheck").is_colliding() or parent.get_node("wallCast").is_colliding():
				parent.motion.x *= -1
				parent.scale.x *= -1
		parent.state_movement.CHASE:
			if !parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("wallCast").is_colliding():
				change_state(parent.state_movement.JUMP)
			if !playerNear:
				yield(get_tree().create_timer(4),"timeout")
				change_state(parent.state_movement.MOVE)
			if parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("emptyGroundCheck").is_colliding():
				change_state(parent.state_movement.MOVE)
			if !parent.get_node("emptyGroundCheck").is_colliding():
				change_state(parent.state_movement.FALL)
		parent.state_movement.JUMP:
			if parent.can_jump:
				parent.motion.y = -250
				parent.can_jump = false
			if get_parent().get_node("emptyGroundCheck").is_colliding():
				parent.can_jump = true
				if !playerNear:
					change_state(parent.state_movement.MOVE)
				else:
					change_state(parent.state_movement.CHASE)
		parent.state_movement.FALL:
			if !parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("wallCast").is_colliding():
				change_state(parent.state_movement.JUMP)
			if parent.get_node("emptyGroundCheck").is_colliding():
				if !playerNear:
					change_state(parent.state_movement.MOVE)
				else:
					change_state(parent.state_movement.CHASE)

func change_state(new_state):
	parent.STATE_MOVE = new_state

func _on_playerDetect_area_entered(area):
	if area.is_in_group("player"):
		playerNear = true

func _on_playerDetect_area_exited(area):
	if area.is_in_group("player"):
		playerNear = false
