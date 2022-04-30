extends Node2D

export var hp : int = 4
var currentHp : int = 4

export var affinity : int = 3
var currentAffinity : int = 3

export var pokemonName = "Squirtle"
export var type = "Water"
onready var texture_heart = $heartPanel.get_node("heart")
onready var texture_heart_filled = load("res://Assets/heartFilled.png")
onready var texture_heart_empty = load("res://Assets/heartEmpty.png")
onready var texture_affinity = $affinityPanel.get_node("affinity")

func _ready():
	currentHp = hp
	currentAffinity = affinity
	$pokemonSprite.texture = load("res://Assets/Pokemon/" + pokemonName + ".png")

	create_hearts()
	create_affinity()

func create_affinity():
	var typeTexture = load("res://Assets/Types/" + type + ".png")
	for x in affinity:
		var instance = texture_affinity.duplicate()
		var name = "affinity" + str(x)
		instance.set_name(name)
		instance.texture = typeTexture
		instance.visible = true
		instance.rect_min_size = Vector2(25 ,25 )
		$affinityPanel.add_child(instance)

func recover_affinity(amount):
	while amount > 0 && currentAffinity < affinity:
		var name = "affinity" + str(currentAffinity-1)
		$affinityPanel.get_node(name).visible = true
		currentAffinity+=1
		amount-=1
	
func consume_affinity(amount):
	
	while amount > 0:
		var name = "affinity" + str(currentAffinity-1)
		$affinityPanel.get_node(name).visible = false
		currentAffinity-=1
		amount-=1

func create_hearts():
	var pixelMult = 0
	if hp >= 8:
		pixelMult = 0.75
	elif hp >= 4:
		pixelMult = 1.25
	else:
		pixelMult = 1.5
	
	for x in hp:
		var instance = texture_heart.duplicate()
		var name = "heart" + str(x)
		instance.set_name(name)
		instance.visible = true
		$heartPanel.add_child(instance)
		instance.rect_min_size = Vector2(10 * pixelMult,21 * pixelMult)

func damage(amount):
	if amount > 0:
		decrement_health(amount)
		

func decrement_health(amount):
	
	while amount > 0:
		var name = "heart" + str(currentHp-1)
		
		$pokemonSprite.visible = false
		yield(get_tree().create_timer(0.25), "timeout")
		
		$pokemonSprite.visible = true
		yield(get_tree().create_timer(0.25), "timeout")
		
		$pokemonSprite.visible = false
		yield(get_tree().create_timer(0.25), "timeout")
		
		$pokemonSprite.visible = true
		yield(get_tree().create_timer(0.25), "timeout")
		
		$heartPanel.get_node(name).texture = texture_heart_empty
		yield(get_tree().create_timer(0.25), "timeout")
		currentHp-=1
		amount-=1

