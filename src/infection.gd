extends Node

class_name Infection

# defines if a dot is contagious, vulnerable or immune to a specific virus
var is_contagious : bool = false setget set_contagious
#var is_infected : bool = false setget set_infected
var is_immune : bool = false setget set_immune
# cannot be set
var is_vulnerable : bool = true setget , get_vulnerable

# which virus is this infection for
var virus : Virus = null setget set_virus

# how long from infection to contagion
var timer_to_contagion : Timer = null
# how long until cured and maybe immune
var timer_to_cure : Timer = null
# how long until death if no help is applied
var timer_to_death : Timer = null

#func set_infected(val: bool):
#	is_infected = val
func set_contagious(val: bool):
	is_contagious = val
func set_immune(val: bool):
	is_immune = val
	
func get_vulnerable():
	# TODO - and not death
	if !is_immune:
		return true
	else: 
		return false

#func get_virus():
#	return virus
#
func set_virus(virus: Virus):
	self.virus = virus
	timer_to_contagion.one_shot = true
	timer_to_contagion.wait_time = virus.time_to_contagion
	timer_to_contagion.start()
	
	timer_to_cure.one_shot = true
	timer_to_cure.wait_time = virus.time_to_cure
	timer_to_cure.start()
	
	timer_to_death.one_shot = true
	timer_to_death.wait_time = virus.time_to_death
	timer_to_death.start()
	
