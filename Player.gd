extends KinematicBody

export var speed = 10.0
export var fall_speed = 6.0
export var jump_speed = 6.0
export var swap_lane_speed = 15.0

var positions = [2.0, .0, -2.0]
var position = 1
var next_position = 1
var is_swap_lane = false
var is_jumping = false
var is_gonna_jump = false
var timer = .0
var jump_time = 0.45

onready var animation = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	var velocity = Vector3.ZERO
	velocity.z = speed
	
	if Input.is_action_just_pressed("jump") and not is_jumping and not is_gonna_jump:
		is_gonna_jump = true
		timer = 0.2
		animation.travel("jump")
	
	if  is_gonna_jump:
		if timer > .0:
			timer -= delta
		else:
			is_gonna_jump = false
			is_jumping = true
			timer = jump_time
	
	if not is_swap_lane:
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left") and position < 2:
			is_swap_lane = true
			next_position += 1
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right") and position > 0:
			is_swap_lane = true
			next_position -= 1
	if is_swap_lane:
		if next_position < position:
			if translation.x + speed * delta > positions[next_position]:
				position = next_position
				is_swap_lane = false
			else:
				velocity.x = swap_lane_speed
		elif next_position > position:
			if translation.x - speed * delta < positions[next_position]:
				position = next_position
				is_swap_lane = false
			else:
				velocity.x = -swap_lane_speed
	if is_jumping and timer > .0:
		velocity.y = jump_speed
		timer -= delta
	else:
		velocity.y = -fall_speed
	velocity = move_and_slide(velocity, Vector3.UP)
	if is_on_floor():
		if is_jumping:
			is_jumping = false
			animation.travel("run")
	else:
		if not is_jumping or is_gonna_jump:
			is_jumping = true
			animation.travel("fall")
