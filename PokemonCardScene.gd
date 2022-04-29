extends Node2D

export var hp : int = 4
var currentHp : int = 4

export var affinity : int = 3
var currentAffinity : int = 3

export var pokemonName = "Squirtle"
export var type = "Water"
var texture_heart

func _ready():
	texture_heart = $heartPanel.get_node("heart")
	currentHp = hp
	currentAffinity = affinity
	$pokemonSprite.texture = load("res://Assets/Pokemon/" + pokemonName + ".png")
	$type.texture = load("res://Assets/Types/" + type + ".png")
	createHearts()

func createHearts():
	for x in hp:
		var instance = texture_heart.duplicate()
		var name = "heart" + str(x)
		instance.set_name(name)
		instance.visible = true
		$heartPanel.add_child(instance)

func damage(amount):
	if amount > 0:
		refresh_health()
		currentHp-= amount

func refresh_health():
	var name = "heart" + str(currentHp-1)
	$heartPanel.get_node(name).visible = false
	

