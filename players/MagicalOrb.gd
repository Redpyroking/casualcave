extends Area2D

var direction = Vector2.RIGHT
var speed = 400
var currentMagic = null

func init(pos,isDirRight):
	global_position = pos
	set_as_toplevel(true)
	if isDirRight:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func _process(delta):
	translate(direction*speed*delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func addMagic(magic):
	match magic:
		"fire":
			currentMagic = "fire"
		"poison":
			currentMagic = "poison"

func _on_MagicalOrb_body_entered(body):
	if body is TileMap:
		queue_free()
	elif body:
		match currentMagic:
			"fire":
				body.burn()
			"poison":
				body.poison()
		queue_free()
