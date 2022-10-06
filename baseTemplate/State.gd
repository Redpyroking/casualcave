extends Node

onready var parent = get_parent()
onready var playerDetect = $"../playerDetect"
var playerNear = false

func _ready():
	call_deferred("change_state",parent.state_movement.IDLE)

func _physics_process(delta):
	match parent.STATE_MOVE:
		parent.state_movement.IDLE:
			if playerNear:
				change_state(parent.state_movement.CHASE)
		parent.state_movement.CHASE:
			if !playerNear:
				change_state(parent.state_movement.IDLE)
			else:
				pass

func change_state(new_state):
	parent.STATE_MOVE = new_state

func _on_playerDetect_area_entered(area):
	if area.is_in_group("player"):
		playerNear = true

func _on_playerDetect_area_exited(area):
	if area.is_in_group("player"):
		playerNear = false
