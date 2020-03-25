extends Node

class_name Infection

# variables can be set from outside
var is_contagious : bool = false setget set_contagious
var is_infected : bool = false setget set_infected
var is_immune : bool = false setget set_immune

# can be read from outside
var is_vulnerable : bool = true setget , get_vulnerable

var virus : Virus = null

var timer_infected : Timer = null

func set_infected(val: bool):
	is_infected = val
func set_contagious(val: bool):
	is_contagious = val
func set_immune(val: bool):
	is_immune = val
	
func get_vulnerable():
	if !is_immune and !is_infected:
		return true
	else: 
		return false
