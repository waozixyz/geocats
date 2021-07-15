extends Node2D
class_name BasePlayerState

export var tag : String = ""

func _ready():
	tag = name.to_lower()


#################################################
# Player State Base
#################################################
func enter_logic(player: KinematicBody2D):
	player.play(tag)

func logic(player: KinematicBody2D, delta: float):
	return null

func exit_logic(player: KinematicBody2D):
	pass
#################################################
