#extends Node
extends Reference

# class_name Virus
#const Infection = preload("res://src/infection.gd")

# how long does it take until someone can spread the virus
const time_to_contagion = 20
# how long does it take for someone to see symptoms
const time_to_symptoms = 50
# how long does it take to get cured (once in hospitality)
const time_to_cure = 100
# how long does it take until you die
const time_to_death = 200

# TODO - missing time variations
# when does cure start?
# what if host does not show symptoms, when does cure start?
# can there be contagious without symptoms
# can there be death without symptoms
# can someone die on age..
# 

# how likely it is to infect other people
const chance_of_infection : float = 0.8
# how likely it is to show symptoms
const chance_of_contagion : float = 1.0
# how likely it is to show symptoms
const chance_of_symptoms : float = 0.7
# how likely it is to be cured at all
const chance_of_cure : float = 0.9
# how likely it is to stay immune after beeing cured
const chance_of_immune : float = 1.0

const infect_radius : float = 2.0
const infect_duration : float = 2.0

# see:  https://www.youtube.com/watch?v=gxAaO2rsdIs
# calculate R (or R0)
# effective / basic reproduction number
# count # transfers
# for every infectious case
# count the number of transfers
# estimate number of transfers or going to happen in total
# average those numbers


# TODO - differ time and chances depending on available hospitality

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func chance(chance: float):
	randomize()
	return randf() < chance
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
