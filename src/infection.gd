extends Node
# only node type can have a _process method
# extends Reference

const TIME_SCALE = 0.1

const COLOR_VULNERABLE = Color.beige # ?
const COLOR_INFECTED = Color.yellow
const COLOR_CONTAGIOUS = Color.orange
const COLOR_SYMPTOMS = Color.red
const COLOR_IMMUNE = Color.green

# TODO - signals may go to host??
signal SIGNAL_VULNERABLE
signal SIGNAL_INFECTED
signal SIGNAL_CONTAGIOUS
signal SIGNAL_SYMPTOMS
signal SIGNAL_CURED
signal SIGNAL_IMMUNE
signal SIGNAL_DEATH

# infection.connect("SIGNAL_VULNERABLE", infection, "on_contagion")
# infection.emit_signal("SIGNAL_CONTAGIOUS")

# depends on other variables, cannot be set
var is_vulnerable : bool = true setget , get_vulnerable
# depends on other variables, cannot be set
var is_not_vulnerable : bool = true setget , get_not_vulnerable
# is set the host is infected by a given virus
var is_infected : bool = false setget set_infected
# whenever a host shows symptoms of an infection
var is_symptoms : bool = false setget set_symptoms
# defines if a Host is contagious
var is_contagious : bool = false setget set_contagious
# shows if the host is already immune to a given virus
var is_immune : bool = false setget set_immune

# which virus is this infection for
var virus = null setget set_virus
var host = null setget set_host

# how long from infection to contagion
var timer_to_contagion : float = -1
# how long from infection to show symptoms
var timer_to_symptoms : float = -1
# how long until cured and maybe immune
var timer_to_cure : float = -1
# how long until death if no help is applied
var timer_to_death : float = -1
	
func set_infected(val: bool):
	is_infected = val
func set_contagious(val: bool):
	is_contagious = val
func set_symptoms(val: bool):
	is_symptoms = val
func set_immune(val: bool):
	is_immune = val

# its only vulnerable if its not immune and not already infected
func get_vulnerable():
	# DONE - death is checked on host side too
	if host and !host.is_dead and !is_immune and !is_infected:
		return true
	else: 
		return false

func get_not_vulnerable():
	# return ! get_vulnerable()
	return self.is_vulnerable

func set_host(h):
	host = h

func set_virus(v):
	virus = v
	timer_to_contagion = virus.time_to_contagion * TIME_SCALE
	timer_to_symptoms = virus.time_to_symptoms * TIME_SCALE
	timer_to_cure = virus.time_to_cure * TIME_SCALE
	timer_to_death = virus.time_to_death * TIME_SCALE
	on_infected()

func _process(delta: float) -> void:
	# reduce timers by delta time
	if timer_to_contagion > 0:
		timer_to_contagion = max(0, timer_to_contagion-delta)
	if timer_to_symptoms > 0:
		timer_to_symptoms = max(0, timer_to_symptoms-delta)
	if timer_to_cure > 0:
		timer_to_cure = max(0, timer_to_cure-delta)
	if timer_to_death > 0:
		timer_to_death = max(0, timer_to_death-delta)
		
	# do stuff on timer timeout
	if timer_to_contagion == 0:
		timer_to_contagion = -1
		on_contagion()
	if timer_to_symptoms == 0:
		timer_to_symptoms = -1
		on_symptoms()
	if timer_to_cure == 0:
		timer_to_cure = -1
		on_cure()
	if timer_to_death == 0:
		timer_to_death = -1
		on_death()

func on_infected():
	# if the host gets the virus, the host is infected
	is_infected = true
	host.set_color(COLOR_INFECTED)
	emit_signal("SIGNAL_INFECTED")
	
func on_contagion():
	if Effects.chance(virus.chance_of_contagion):
		is_contagious = true
		host.set_color(COLOR_CONTAGIOUS)
		emit_signal("SIGNAL_CONTAGIOUS")

func on_symptoms():
	if Effects.chance(virus.chance_of_symptoms):
		is_symptoms = true
		host.set_color(COLOR_SYMPTOMS)
		emit_signal("SIGNAL_SYMPTOMS")

func on_cure():
	if Effects.chance(virus.chance_of_cure):
		is_infected = false
		is_contagious = false
		is_symptoms = false
		timer_to_death = -1
		host.set_color(COLOR_VULNERABLE)
		emit_signal("SIGNAL_CURED")
		
		if Effects.chance(virus.chance_of_immune):
			is_immune = true
			host.set_color(COLOR_IMMUNE)
			emit_signal("SIGNAL_IMMUNE")
			
		else:
			# was not immunized
			pass
	else:
		# could not be cured..
		# another try after timer_to_cure
		timer_to_cure = virus.time_to_cure
		pass
	
func on_death():
	# only die if you show symptoms
#	if is_symptoms :
	timer_to_death = -1
	timer_to_contagion = -1
	timer_to_cure = -1
	timer_to_symptoms = -1
	host.is_dead = true
	is_symptoms = false
	is_contagious = false
	is_immune = false
	is_infected = false
	host.set_color(host.COLOR_DEATH)
	emit_signal("SIGNAL_DEATH")
