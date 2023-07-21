extends "res://baseTemplate/entity.gd"

enum Class {human,elf,demon,dwarf,goblin,orc,orge,
			android,mutant}
export(Class) var ClassType
enum Job {Mage,Warlock,Warrior,Archer,Trickster,Tank,Healer}
export (Job) var JobType
onready var healthBar = $healthBar
var motion = Vector2()
const GRAVITY = 600
export var speed = 40
var levelNavigation:Navigation2D= null
var path :Array= []
onready var line2d = $Line2D

var knockback = 100
var knockup = 300
var playerNear = false
var can_jump = true

enum all_state {IDLE,MOVE,CHASE,SEARCH,SLEEP,PICKUP,RETREAT,DEAD}
export (all_state) var STATE
enum attack_state {NONE,ATTACK}
export (attack_state) var ATTACK_STATE
var is_attacking = false
var tile_generated = false
var out_of_screen = false
var los_collide = false

func _ready():
	STATE = all_state.IDLE
	ATTACK_STATE = attack_state.NONE
	hp = maxHp
	healthBar.max_value = maxHp
	healthBar.value = hp
	yield(get_tree(),"idle_frame")
	var tree =get_tree()
	if tree.has_group("Navigator"):
		levelNavigation = tree.get_nodes_in_group("Navigator")[0]

var seen = false
var chaseCooled = false

func _physics_process(delta):
	check_room_generate()
	$Label.text = str(attack_state.keys()[ATTACK_STATE])
	check_status()
	healthBar.value = hp
	if hp < 1:
		die()
	damageLabel.rect_scale.x = scale.y
	out_of_screen = !$VisibilityNotifier2D.is_on_screen()
	los_collide = $lineOfSight.is_colliding()
	if tile_generated:
		$lineOfSight.look_at(Global.Player.global_position)

func check_status():
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

func movement(delta):
	line2d.global_position = Vector2.ZERO
	if levelNavigation:
		generate_path()
		navigate()
	motion = move_and_slide(motion)
	linear_dir = stepify(-(motion.angle() - PI/2) , PI/4) / (PI/4)
	linear_dir = wrapi(int(linear_dir), 0, 8)

func navigate():
	if path.size() >0:
		motion = global_position.direction_to(path[1]) * speed
		if global_position == path[0]:
			path.pop_front()

func generate_path():
	if levelNavigation:
		path = levelNavigation.get_simple_path(global_position,Global.Player.global_position,false)
		line2d.points = path

func die():
	healthBar.hide()
	$AnimationPlayer.play("died")
	if STATE != all_state.DEAD:
		$deathTimer.start()
		STATE = all_state.DEAD
	if $deathTimer.time_left < 2:
		$damageShowAnime.play("dieingModulate")

func checkHealth(stat) -> int:
	if status.has(stat):
		return 1
	else:
		return 0

func _on_healthTimer_timeout():
	pass

func _on_hitbox_area_entered(area):
	pass

func jump():
	if can_jump:
		motion.y -= 80
		can_jump = false

func knock(distance_bool):
	pass
#	can_jump = false
#	motion.x = lerp(motion.x,-knockup,0.5)
#	motion = move_and_slide(motion,Vector2.UP)

func _on_AttackBox_area_entered(area):
	if area.is_in_group("player"):
		area.get_parent().knock(global_position>area.global_position)

func _on_AttackBox_area_exited(area):
	pass # Replace with function body.


func _on_deathTimer_timeout():
	queue_free()

var has_set_pos = false
func check_room_generate():
	var map = get_tree().get_root().find_node("TileMap",true,false)
	if map.has_room_generated and !has_set_pos:
		var p = get_tree().get_root().find_node("player",true,false)
		global_position = p.global_position
		tile_generated = true
		has_set_pos = true

