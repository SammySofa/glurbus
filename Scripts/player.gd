extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

var facing_right = true
var is_jumping = false
var is_falling = false
var is_landing = false


func _physics_process(delta):

	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		is_landing = false


	var direction = Input.get_axis("left", "right")
	if direction > 0:
		facing_right = true
	elif direction < 0:
		facing_right = false
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()
	update_animation()

func update_animation():
	var suffix = "_R" if facing_right else "_L"
	
	if is_landing:
		if not animated_sprite.is_playing() or animated_sprite.animation != "landing" + suffix or velocity.x != 0:
			is_landing = false
		else:
			return
	
	# In air
	if not is_on_floor():
		if velocity.y < 0:  # Going up
			if is_jumping:
				animated_sprite.play("jumpstart" + suffix)
				is_jumping = false
			elif animated_sprite.animation != "goingup" + suffix:
				animated_sprite.play("goingup" + suffix)
		else:  # Falling
			if not is_falling:
				animated_sprite.play("fallingstart" + suffix)
				is_falling = true
			elif animated_sprite.animation != "falling" + suffix:
				animated_sprite.play("falling" + suffix)
	# On ground
	else:
		if is_falling:
			animated_sprite.play("landing" + suffix)
			is_falling = false
			is_landing = true
		elif velocity.x != 0:
			if animated_sprite.animation != "running" + suffix and animated_sprite.animation != "startrun" + suffix:
				animated_sprite.play("startrun" + suffix)
			elif animated_sprite.animation == "startrun" + suffix and not animated_sprite.is_playing():
				animated_sprite.play("running" + suffix)
		else:
			animated_sprite.play("idle" + suffix)

func attack():
	var suffix = "_R" if facing_right else "_L"
	animated_sprite.play("attack" + suffix)
