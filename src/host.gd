extends KinematicBody2D
#extends Reference

const COLOR_BASE = Color.gray
const COLOR_DEATH = Color.black
const TRAIL_MAX_LENGTH = 15

# TODO - get each host a randomize name
onready var sprite = get_node("Sprite")
onready var outline = get_node("Outline")
onready var area = get_node("Area")
onready var area_shape = get_node("Area/Shape")
onready var infections = get_node("Infections")

### host attributes
# whenever a dot is dead
var is_dead : bool = false setget set_dead
# whenever a dot is in quarantined
var is_quarantined : bool = false setget set_quarantined
# whenever a dot is in hospital
var is_hospitalized : bool = false setget set_hospitalized

# city in which the host belongs to
var city: Node

var trail: Line2D

# movement direction
var direction : Vector2 = Vector2(0,0)
var direction_evade : Vector2 = Vector2(0,0)
# current speed, comes from city, will be set in birth
var movement_speed


# temporary variables
var tmp_delta = 0

### infection attributes
# those getters will search through all current infections of a host
# is set the host is infected by a given virus
var is_infected : bool = false setget , get_infected
# whenever a host shows symptoms of an infection
var is_symptoms : bool = false setget , get_symptoms
# defines if a Host is contagious
var is_contagious : bool = false setget , get_contagious

func set_dead(val: bool):
	is_dead = val
	if val:
		is_quarantined = false
		is_hospitalized = false
func set_quarantined(val: bool):
	is_quarantined = val
func set_hospitalized(val: bool):
	is_hospitalized = val

func get_infected() -> bool:
#	return find_infection('is_infected', null)
	return is_infected
func get_symptoms() -> bool:
#	return find_infection('is_symptoms', null)
	return is_symptoms
func get_contagious() -> bool:
#	return find_infection('is_contagious', null)
	return is_contagious

# find a given attribute from any (null) or a specific virus
func find_infection(attribute, virus = null):
	if infections.get_child_count() > 0:
		for infection in infections.get_children():
			if virus == null or infection.virus == virus:
				return infection.get(attribute)
	if virus == null : 
		return false
	else:
		return null

func on_infection_change(attribute, value):
	if attribute in self:
		self.set(attribute, value)

# when a dot is infected by a virus, it get added to the list of infections
func infect(virus):
	#var infection : Infection
	# create a new infection based on given virus
	# for reference
	# var infection = load("res://src/infection.gd").new()
	# for nodes
	var infection = load("res://src/infection.tscn").instance()
	# TODO - change here to duplicate/clone - instead of ref
	infection.host = self
	infection.virus = virus
	infection.connect("SIGNAL_INFECTION_CHANGE", self, "on_infection_change")
	
	# add infection to hosts list
	infections.add_child(infection)
	
	# return it, for later use..
	return infection

# check if a virus can infect the host
func infectable(virus) -> bool:
	var is_vulnerable = true
	# TODO - even a dead body could be vulnerable
	if is_dead:
		return false
	else:
		# vulnerable is only true, if not already infected and not immune
		# not_vulnerable is the opposite
		# if there is no infection with the given virus, null is returned
		# in that case, the host is vulnerable
		is_vulnerable = find_infection('is_not_vulnerable', virus)
		if is_vulnerable == null:
			is_vulnerable = true
	return is_vulnerable

# if dot meets another dot
func meet(encounter):
	# go through all my current infections
	# check if encounter is voluarable
	if infections.get_child_count() > 0:
		for infection in infections.get_children():
			# for each infection that is still contagious
			# check if the encounter is still vulnerable
			# and infect encounter only if chance is successfull
			if infection.is_contagious and \
				encounter.infectable(infection.virus) and \
				Effects.chance(infection.virus.chance_of_infection):
				encounter.infect(infection.virus)

# Called when the node enters the scene tree for the first time.
func _ready():
	# start color
	set_color(COLOR_BASE)
	# start position
	var boundary : Rect2 = city.get_boundaries()
	var x = boundary.size.x
	var y = boundary.size.y
	randomize()
	position = Vector2(randf() * x*2 - x, randf() * y*2 -y)
	# start direction
	direction = Vector2(randf() * 2 -1, randf() * 2 -1)
	
	movement_speed = city.movement_speed
	area_shape.shape.radius = city.social_distance
	
	add_to_group("HOST")

func birth(city):
	self.city = city
	
	# add trail
	trail = Line2D.new()
	trail.width = 1
	# hide it
	trail.visible = false
	city.get_node("trails").add_child(trail)
	
func _physics_process(delta: float) -> void:

	tmp_delta += delta

	if tmp_delta > 0.1:
		tmp_delta -= 0.1
		add_trail(self.global_position)
	
	# if host is dead - slowing down until stopping
	if is_dead:
		movement_speed *= 0.99
		direction *= 0.99
		trail.visible = false
	
	if is_symptoms:
		trail.visible = true
		if !has_sound():
			# if symptoms are shown - make some noise
			Effects.cough(self)

	set_outline(sprite.modulate)
	
	# check which hosts are nearby
	var nearby_infected = false
	var nearby_hosts = area.get_overlapping_areas()
	if len(nearby_hosts) > 0:
		for nearby_host in nearby_hosts:
			
			var collision_vector = nearby_host.global_position - self.position
			var normalized_direction = collision_vector.normalized()
			var inverse_distance = area_shape.shape.radius*2 - collision_vector.length()
			var inverse_distance_lerped = 1 - inverse_lerp(0, area_shape.shape.radius*2, collision_vector.length())
#				var inverse_distance_lerped = 1 - inverse_lerp(0, pow(area_shape.shape.radius*2, 2), pow(collision_vector.length(),2) )
#
#				print("positions: ", nearby_host.position, " self: ", self.position)
#				print("area_shape.shape.radius: ", area_shape.shape.radius)
#				print("collision_vector: ", collision_vector)
#				print("vector_length: ", collision_vector.length())
#				print("normalized_direction: ", normalized_direction)
#				print("inverse_distance: ", inverse_distance)
#				print("inverse_distance_lerped: ", inverse_distance_lerped)
#				print("#####")
			
			if nearby_host.owner.is_symptoms and not is_dead:
				direction_evade -= inverse_distance_lerped * normalized_direction * delta
				nearby_infected = true
				set_outline(Color.pink)
			if is_symptoms and not nearby_host.owner.is_dead:
				nearby_host.owner.direction_evade += inverse_distance_lerped * normalized_direction * delta
				nearby_host.owner.set_outline(Color.black)
#				nearby_host.owner.direction = nearby_host.owner.direction + (inverse_distance_lerped * normalized_direction * delta)

	# if no infections are nearby - slowdown
	if nearby_infected == false:
		direction_evade = Vector2(0,0)
		
	 # Get velocity
	var velocity = movement_speed * (direction + direction_evade)
	
	# if host show symptoms, drop movement speed
	if self.is_symptoms:
		velocity /= 1.5
	
	move_and_slide(velocity)
	# check if there is a collision:
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			# bounce on collision
			direction = direction.bounce(collision.normal)
			direction_evade = direction_evade.bounce(collision.normal)
			if collision.collider.get_script() == load("res://src/host.gd"):
				# if 2 hosts meet
				meet(collision.collider)
	else: # only if no collision was registered
		pass

func add_trail(point: Vector2):
	trail.add_point(point)
	if len(trail.points) > TRAIL_MAX_LENGTH:
		trail.remove_point(0)

# check if current node does already have a sound set
func has_sound():
	return has_node("sound")

# change color modulation of host
func set_color(color: Color):
	sprite.modulate = color
func set_outline(color: Color):
	outline.modulate = color
