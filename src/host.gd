extends KinematicBody2D
#extends Reference

# class_name Host

const COLOR_BASE = Color.gray
const COLOR_DEATH = Color.black

#const Virus = preload("res://src/virus.gd")
#const Infection = preload("res://src/infection.gd")

# TODO - get each host a randomize name

onready var sprite = get_node("Sprite")
onready var infections = get_node("Infections")

#var infections: Array = Array()


# whener a dot is dead
var is_dead : bool = false setget set_dead
var direction : Vector2 = Vector2(0,0)
var speed = 30

func set_dead(val: bool):
	is_dead = val

# when a dot is infected by a virus, it get added to the list of infections
func infect(virus):
	#var infection : Infection
	# create a new infection based on given virus
	# for reference
	#var infection = load("res://src/infection.gd").new()
	# for nodes
	var infection = load("res://src/infection.tscn").instance()
	# TODO - change here to duplicate/clone - instead of ref
	infection.host = self
	infection.virus = virus
	# add infection to hosts list
#	infections.append(infection)
	infections.add_child(infection)

	# infection.connect("SIGNAL_VULNERABLE", infection, "on_contagion")
	# infection.emit_signal("SIGNAL_CONTAGIOUS")
	
	# return it, for later use..
	return infection

# check if a virus can infect the host
func infectable(virus):
#func infectable(virus):
	var is_vulnerable = true
	# TODO - even a dead body could be vulnerable
	if is_dead:
		is_vulnerable = false
	#elif len(infections) > 0:
	elif infections.get_child_count() > 0:
		# if i have the virus in question
		# and if I am immune
		# than I cannot get the virus again
		for infection in infections.get_children():
			if infection.virus == virus and \
				! infection.is_vulnerable:
				is_vulnerable = false
				break
	return is_vulnerable

# if dot meets another dot
func meet(encounter):
	
	# go through all my current infections
	# check if encounter is voluarable 
#	if len(infections) > 0:
	if infections.get_child_count() > 0:
		#print('i could infect somebody')
		for infection in infections.get_children():
			# for each infection that is still contagious
			# check if the encounter is still vulnerable
			# and infect encounter only if chance is successfull
			if infection.is_contagious and \
				encounter.infectable(infection.virus) and \
				infection.virus.chance(infection.virus.chance_of_infection):
				encounter.infect(infection.virus)
			
#	if d1.is_contagious and d2.is_vulnerable:
#		if chance(chance_to_infection):
#			d2.infect(self)
#
#	elif d2.is_contagious and d1.is_vulnerable:
#		d1.is_infected = chance(chance_to_infection)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(COLOR_BASE)
	position = Vector2(randf() * 400 -200, randf() * 400 -200)
#	Vector2 move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ), 
#	stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true)

	direction = Vector2(randf() * 400 -200, randf() * 400 -200)

	#move_and_slide(, floor_direction=Vector2(0,0), slope_stop_min_velocity=5,max_bounces=4)

#func _physics_process(delta: float) -> void:
func _process(delta: float) -> void:
	 # Get velocity
	var velocity = speed * delta * direction # move slow? increases speed or multiply this x 100
	# move and slide:
	if !is_dead:
		move_and_slide(velocity)
	# check if there is a collision:
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			direction = direction.bounce(collision.normal) # do ball bounce
#			if collision.collider extends load('res://src/hosts.gd'):
			if collision.collider.get_script() == load("res://src/host.gd"):
				meet(collision.collider)
				#print('i met another host')


func set_color(color: Color):
	sprite.modulate = color
#	call_deferred("_set_color", color)
	
#func _set_color(color: Colo#r):
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
