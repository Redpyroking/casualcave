extends Node

onready var parent = get_parent()
onready var playerDetect = $"../playerDetect"
var playerNear = false

func _ready():
	randomize()
	call_deferred("change_state",parent.all_state.IDLE)

func _physics_process(delta):
	match parent.STATE:
		parent.all_state.IDLE:
#			if playerNear:
#				change_state(parent.all_state.CHASE)
			if parent.get_node("checkFloor").is_colliding():
				change_state(parent.all_state.MOVE)
		parent.all_state.MOVE:
#			if playerNear:
#				change_state(parent.all_state.CHASE)
			if !parent.get_node("checkFloor").is_colliding() and parent.can_jump:
				if !parent.get_node("floorFallCheck").is_colliding():
					parent.motion.x *= -1
					parent.scale.x *= -1
			if parent.get_node("checkWall").is_colliding():
				if parent.get_node("wallJumpCheck").is_colliding():
					parent.motion.x *= -1
					parent.scale.x *= -1
				else:
					parent.jump()
				
#		parent.all_state.CHASE:
#			if !parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("wallCast").is_colliding():
#				parent.jump()
#			if !playerNear:
#				change_state(parent.all_state.SEARCH)
#			if parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("emptyGroundCheck").is_colliding():
#				change_state(parent.all_state.IDLE)
#		parent.all_state.SEARCH:
#			if playerNear:
#				change_state(parent.all_state.CHASE)
#			if Global.Player.global_position.x > parent.global_position.x and parent.scale.y == -1:
#				parent.motion.x *= -1
#				parent.scale.x = -1
#			elif Global.Player.global_position.x < parent.global_position.x and parent.scale.y == 1:
#				parent.motion.x *= -1
#				parent.scale.x = -1
#			if !parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("wallCast").is_colliding():
#				parent.jump()
#			else:
#				yield(get_tree().create_timer(4),"timeout")
#				if !playerNear:
#					change_state(parent.all_state.MOVE)
#				else:
#					change_state(parent.all_state.CHASE)

func change_state(new_state):
	parent.STATE = new_state

func _on_playerDetect_area_entered(area):
	if area.is_in_group("player"):
		playerNear = true

func _on_playerDetect_area_exited(area):
	if area.is_in_group("player"):
		playerNear = false
