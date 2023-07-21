extends Node

onready var parent = get_parent()
onready var playerDetect = $"../playerDetect"
var inCombatArea = false
var timeIdle = 0
var startTimer = true

func _ready():
	randomize()
	call_deferred("change_state",parent.all_state.IDLE)

func _physics_process(delta):
	if parent.tile_generated:
		set_state(delta)


func set_state(delta):
	match parent.STATE:
		parent.all_state.IDLE:
			if !parent.is_attacking:
				parent.get_node("Sprite").play("default")
			if parent.playerNear and !parent.los_collide:
				change_state(parent.all_state.CHASE)
		parent.all_state.CHASE:
			if parent.playerNear:
					parent.seen = true
					parent.get_node("chaseCooldown").start(parent.get_node("chaseCooldown").wait_time)
			elif parent.out_of_screen:
				if parent.seen:
					if !parent.chaseCooled:
						parent.get_node("chaseCooldown").start()
						parent.chaseCooled = true
			if parent.seen:
				parent.get_node("Sprite").flip_h = Global.Player.global_position.x > parent.global_position.x
				parent.get_node("playerDetect").scale.x = -( 2 * int(!parent.get_node("Sprite").flip_h) - 1)
				if parent.global_position.distance_to(Global.Player.global_position) > 15:
					parent.movement(delta)
				if !parent.is_attacking:
					parent.get_node("Sprite").play("walk")
			else:
				change_state(parent.all_state.IDLE)
	match parent.ATTACK_STATE:
		parent.attack_state.ATTACK:
			if !parent.is_attacking:
				parent.is_attacking = true
				parent.get_node("Sprite").play("attack")
			if parent.global_position.distance_to(Global.Player.global_position) > 20:
				change_combat_state(parent.attack_state.NONE)
		parent.attack_state.NONE:
			parent.is_attacking = false
			if parent.global_position.distance_to(Global.Player.global_position) <= 20:
				change_combat_state(parent.attack_state.ATTACK)

func change_state(new_state):
	parent.STATE = new_state

func change_combat_state(new_combat_state):
	parent.ATTACK_STATE = new_combat_state

func _on_playerDetect_area_entered(area):
	if area.is_in_group("player"):
		parent.playerNear = true

func _on_playerDetect_area_exited(area):
	if area.is_in_group("player"):
		parent.playerNear = false

func _on_combatArea_area_entered(area):
	if area.is_in_group("player"):
		inCombatArea = true

func _on_combatArea_area_exited(area):
	if area.is_in_group("player"):
		inCombatArea = false

func get_circle_position(random):
	var kill_circle_centre = Global.Player.global_position
	var radius = 40
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)

func _on_chaseCooldown_timeout():
	parent.seen = false
	parent.chaseCooled = false
	parent.get_node("chaseCooldown").stop()
