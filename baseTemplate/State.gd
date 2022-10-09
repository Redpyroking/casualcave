extends Node

onready var parent = get_parent()
onready var playerDetect = $"../playerDetect"
var playerNear = false
var timeIdle = 0
var startTimer = true

func _ready():
	randomize()
	call_deferred("change_state",parent.all_state.MOVE)

func _physics_process(delta):
	print($StateTimer.time_left)
	match parent.STATE:
		parent.all_state.IDLE:
			pass
			if playerNear:
				parent.is_moving = true
				change_state(parent.all_state.CHASE)
#			if !parent.is_moving:
#				yield(get_tree().create_timer(rand_range(1,4)),"timeout")
#				change_state(parent.all_state.MOVE)
#			if !(parent.get_node("checkBackOccupied").is_colliding() or parent.get_node("checkWall").is_colliding()):
#				parent.motion.x *= -1
#				parent.scale.x *= -1
#				change_state(parent.all_state.MOVE)
		parent.all_state.MOVE:
			if playerNear:
				change_state(parent.all_state.CHASE)
			if (parent.get_node("checkBackOccupied").is_colliding() and parent.get_node("checkWall").is_colliding() and parent.get_node("wallJumpCheck").is_colliding()):
				parent.motion.x *= -1
				parent.scale.x *= -1
				yield(get_tree().create_timer(0.2),"timeout")
				if parent.get_node("wallJumpCheck").is_colliding():
					change_state(parent.all_state.IDLE)
			elif !parent.get_node("checkFloor").is_colliding() and parent.can_jump:
				if !parent.get_node("floorFallCheck").is_colliding():
					parent.motion.x *= -1
					parent.scale.x *= -1
			elif parent.get_node("checkWall").is_colliding() and parent.get_node("wallJumpCheck").is_colliding():
				parent.motion.x *= -1
				parent.scale.x *= -1
			elif parent.get_node("checkWall").is_colliding() and !parent.get_node("wallJumpCheck").is_colliding():
				parent.jump()
		parent.all_state.CHASE:
			if !parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("checkWall").is_colliding():
				parent.jump()
			if !playerNear:
				change_state(parent.all_state.SEARCH)
			if parent.get_node("wallJumpCheck").is_colliding() and !parent.get_node("checkFloor").is_colliding():
				change_state(parent.all_state.IDLE)
		parent.all_state.SEARCH:
			if playerNear:
				$StateTimer.stop()
				startTimer = true
				change_state(parent.all_state.CHASE)
			elif (parent.get_node("checkBackOccupied").is_colliding() and parent.get_node("checkWall").is_colliding() and parent.get_node("wallJumpCheck").is_colliding()):
				parent.motion.x *= -1
				parent.scale.x *= -1
				yield(get_tree().create_timer(0.2),"timeout")
				if parent.get_node("wallJumpCheck").is_colliding():
					$StateTimer.stop()
					startTimer = true
					change_state(parent.all_state.IDLE)
			elif !parent.get_node("checkFloor").is_colliding() and parent.can_jump:
				if !parent.get_node("floorFallCheck").is_colliding():
					parent.motion.x *= -1
					parent.scale.x *= -1
			elif parent.get_node("checkWall").is_colliding() and parent.get_node("wallJumpCheck").is_colliding():
				parent.motion.x *= -1
				parent.scale.x *= -1
			elif randi() % 250 == 0:
				parent.motion.x *= -1
				parent.scale.x *= -1
			elif !parent.get_node("wallJumpCheck").is_colliding() and parent.get_node("checkWall").is_colliding():
				parent.jump()
			else:
				if startTimer:
					$StateTimer.start()
					startTimer = false

func change_state(new_state):
	parent.STATE = new_state

func _on_playerDetect_area_entered(area):
	if area.is_in_group("player"):
		playerNear = true

func _on_playerDetect_area_exited(area):
	if area.is_in_group("player"):
		playerNear = false

func _on_StateTimer_timeout():
	if parent.STATE == parent.all_state.SEARCH:
		if !playerNear:
			change_state(parent.all_state.MOVE)
		else:
			change_state(parent.all_state.CHASE)
	startTimer = true
