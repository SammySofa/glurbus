extends AnimatedSprite2D

@onready var animated_sprite = $Player/AnimatedSprite2D
var speed = 200.0

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		if direction < 0:
			animated_sprite.play("run_L")
		else:
			animated_sprite.play("run_R")


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
