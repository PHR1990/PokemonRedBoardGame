extends Node

onready var dictionary = load("res://Scripts/DataDictionary.gd").new()

func get_pokemon(name:String) -> Pokemon:
	return dictionary.pokemon[name]

func get_move(name:String) -> Move:
	return dictionary.moves[name]
