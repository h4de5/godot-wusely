extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const host = preload("res://src/host.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_hosts()
	
func set_hosts():
	
	for i in range(80):
		get_node("hosts").add_child(host.instance())
	outbreak()
	
func outbreak():
	var virus = load("res://src/virus.gd").new()
	var patient0 = host.instance()
	get_node("hosts").add_child(patient0)
	patient0.infect(virus)
	
