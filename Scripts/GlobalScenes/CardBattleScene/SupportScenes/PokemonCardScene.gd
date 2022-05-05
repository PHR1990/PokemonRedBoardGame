extends Node2D

export var hp : int = 4
export var currentHp : int = -1

export var affinity : int = 3
export var currentAffinity : int = 3

export var pokemonName = "Squirtle"
export var type = "Water"
onready var texture_heart = $heartPanel.get_node("heart")
onready var texture_heart_filled = load("res://Assets/heartFilled.png")
onready var texture_heart_empty = load("res://Assets/heartEmpty.png")
onready var texture_affinity = $affinityPanel.get_node("affinity")

func _ready():
	if currentHp < 0:
		currentHp = hp
	#currentHp = hp
	currentAffinity = affinity
	$pokemonSprite.texture = load("res://Assets/Pokemon/" + pokemonName + ".png")

	create_hearts()
	create_affinity()
	$Timer.start()

func _on_Timer_timeout():
	animate()
	$Timer.start()
	
func animate():
	$pokemonSprite.set_frame(1)
	yield(get_tree().create_timer(.5), "timeout")
	$pokemonSprite.set_frame(0)
	
func create_affinity():
	var typeTexture = load("res://Assets/Types/" + type + ".png")
	var pixelMult = 0
	if affinity >= 6:
		pixelMult = 0.5
	elif affinity >= 5:
		pixelMult = 0.75
	elif affinity >= 4:
		pixelMult = 1
	else:
		pixelMult = 1.5
		
	for x in affinity:
		var instance = texture_affinity.duplicate()
		var name = "affinity" + str(x)
		instance.set_name(name)
		instance.texture = typeTexture
		instance.visible = true
		instance.rect_min_size = Vector2(25.0 * pixelMult,25.0 * pixelMult)
		$affinityPanel.add_child(instance)

func recover_affinity(amount):
	while amount > 0 && currentAffinity < affinity:
		var name = "affinity" + str(currentAffinity)
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
	if hp >= 6:
		pixelMult = 0.50
	elif hp >= 4:
		pixelMult = 0.75
	else:
		pixelMult = 1
	
	for x in hp:
		var instance = texture_heart.duplicate()
		var name = "heart" + str(x)
		instance.set_name(name)
		instance.visible = true
		$heartPanel.add_child(instance)
		instance.rect_min_size = Vector2(25.0 * pixelMult,10.0 * pixelMult)
	
	for x in range(currentHp, hp):
		var name = "heart" + str(x)
		$heartPanel.get_node(name).texture = texture_heart_empty

func damage(amount):
	if amount > 0:
		decrement_health(amount)

func decrement_health(amount):
	
	while amount > 0 && currentHp > 0:
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
	
	if currentHp < 1:
		$pokemonSprite.visible = false

