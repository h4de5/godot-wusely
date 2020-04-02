extends Node

# a single host
const host = preload("res://src/host.tscn")

### city attributes
export var movement_speed = 1.2
export var citizens = 120
export var hospital_beds = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	set_hosts()

func set_hosts():
	var citizen
	for i in range(citizens):
		citizen = host.instance()
		citizen.birth(self)
		get_node("hosts").add_child(citizen)
	outbreak()

func outbreak():
	var virus = load("res://src/virus.gd").new()
	var patient0 = host.instance()
	patient0.birth(self)
	get_node("hosts").add_child(patient0)
	patient0.infect(virus)
