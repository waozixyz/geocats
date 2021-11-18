extends Node2D
class_name BasePlayerState

export var tag : String = ""

func _ready():
	tag = name.to_lower()


#################################################
# Player State Base
#################################################
func enter_logic(_player: KinematicBody2D):
	pass

func logic(_player: KinematicBody2D, _delta: float):
	return null

func exit_logic(_player: KinematicBody2D):
	pass
#################################################
