extends Node2D
class_name PlayerFSM

var states : Dictionary = {}
var previous_state_tag: String 
var active_state: BasePlayerState
var player : KinematicBody2D

func generate_state_dictionary():
	for state in get_children():
		if state.tag:
			states[state.tag] = state

func enter_logic(player: KinematicBody2D):
	self.player = player
	generate_state_dictionary()
	active_state = states.idle
	active_state.enter_logic(self.player)


func logic(delta: float):
	var next_state_tag = active_state.logic(player, delta)
	if next_state_tag:
		change_state(next_state_tag)

func change_state(var next_state_tag : String):
	previous_state_tag = active_state.tag
	var next_state = states.get(next_state_tag)
	if next_state:
		active_state.exit_logic(player)
		active_state = next_state
		active_state.enter_logic(player)
