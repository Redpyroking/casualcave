extends "res://baseTemplate/entity.gd"

enum Class {human,elf,demon,dwarf,goblin,orc,orge,
			android,mutant}
export(Class) var ClassType
enum Job {Mage,Warlock,Warrior,Archer,Trickster,Tank,Healer}
export (Job) var JobType
var status = []
var max_hp = 100
onready var healthBar = $healthBar
var motion = Vector2()
const GRAVITY = 600
var speed = 40

var knockback = 100
var knockup = 300
var jump = false
var playerNear = false

enum state_movement {IDLE,CHASE,JUMP,PICKUP,RETREAT,SEARCH}
export (state_movement) var STATE_MOVE
enum state_attack {IDLE,ATTACK}

func _ready():
	hp = max_hp
	healthBar.max_value = max_hp
	healthBar.value = hp
	motion.x = speed

func _physics_process(delta):
	movement(delta)
	$Label.text = str(state_movement.keys()[STATE_MOVE])
	if status.has("burn"):
		if hp > 0:
			if checkHealth("burn") == 1 and $healthTimer.is_stopped():
				hp -= 1
				$healthTimer.wait_time = 0.2
				$healthTimer.start()
	if status.has("poison"):
		if hp > 0:
			if checkHealth("poison") == 1 and $healthTimer.is_stopped():
				hp -= 1
				$healthTimer.wait_time = 0.6
				$healthTimer.start()
	healthBar.value = hp
	if hp < 1:
		queue_free()
#	print(status)

func hurt(value):
	hp -= value

func movement(delta):
	if !is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, 300)
	else:
		motion.y = 0
	if $floorRay.is_colliding():
		jump = false
		$floorRay.enabled = false
	if !jump:
		if !$RayCast2D.is_colliding():
			motion.x *= -1
			scale.x *= -1
	if $wallCast.is_colliding():
		motion.x *= -1
		scale.x *= -1
	move_and_slide(motion,Vector2.UP)

func burn():
	if status.has("wet"):
		status.erase("wet")
		status.erase("burn")
	elif status.has("burn"):
		print("already burning")
		$StatusTimers/burnTime.start()
	else:
		status.append("burn")
		$StatusTimers/burnTime.start()
		print("burning")

func poison():
	if status.has("poison"):
		print("already poisoned")
		$StatusTimers/poisonTime.start()
	else:
		status.append("poison")
		$StatusTimers/poisonTime.start()
		print("poisoned")

func checkHealth(stat) -> int:
	if status.has(stat):
		return 1
	else:
		return 0

func _on_healthTimer_timeout():
	pass

func _on_burnTime_timeout():
	status.erase("burn")

func _on_poisonTime_timeout():
	status.erase("poison")

func _on_hitbox_area_entered(area):
	if area.is_in_group("player"):
		area.get_parent().knock(global_position>area.global_position)

func knock(distance_bool):
	jump = true
	$floorRay.enabled = true
	motion.y = lerp(motion.y,-knockup,0.5)
	motion = move_and_slide(motion,Vector2.UP)

