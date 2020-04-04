extends Node

# a single host
const host = preload("res://src/host.tscn")

### city attributes
export var movement_speed = 100
export var citizens = 120
export var hospital_beds = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	create_hosts()

func get_boundaries():
#	var rect= get_viewport_rect()
#	rect.get_position_in_parent()
#	get_node("border").get_position_in_parent()
#	get_node("border").get
##	Rect2
	return Rect2(Vector2(10,10), Vector2(450,250))

# add all hosts to the city scene
func create_hosts():
	var citizen
	for i in range(citizens):
		citizen = host.instance()
		citizen.birth(self)
		get_node("hosts").add_child(citizen)
	outbreak()

# set the virus free
func outbreak():
	printerr("So it begins..")
	
	var virus = load("res://src/virus.gd").new()
	var patient0 = host.instance()
	patient0.birth(self)
	get_node("hosts").add_child(patient0)
	patient0.infect(virus)
