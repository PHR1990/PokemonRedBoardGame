extends Node

onready var dictionary = load("res://Scripts/Repository.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.display_enemy_card("Squirtle")
	
	$HUD.display_own_pokemon_card("Charmander")
	
	$HUD.display_move_card(1, "Scratch")
	$HUD.display_move_card(2, "Ember")
	
	$HUD.connect("change_pokemon_card_pressed", self, "_change_card")
	$HUD.connect("move_card_was_pressed", self, "_move_card_pressed")


func _change_card(position):
	if position == 1:
		$HUD.display_own_pokemon_card("Squirtle")
		$HUD.display_move_card(1, "Tackle")
		$HUD.display_move_card(2, "Bubble")
	elif position == 2:
		$HUD.display_own_pokemon_card("Pikachu")
		$HUD.display_move_card(1, "Nuzzle")
		$HUD.display_move_card(2, "Growl")
	else:
		$HUD.display_own_pokemon_card("Charmander")
		$HUD.display_move_card(1, "Scratch")
		$HUD.display_move_card(2, "Ember")
		
func _move_card_pressed(moveName):
	$HUD.reset_label()
	var ownMove = dictionary.moves.get(moveName)
	var enemyMove = dictionary.moves.get(random_move())
	
	var result = rock_paper_scissor_result(ownMove.badge, enemyMove.badge)
	
	$HUD.display_text("You choose: " + ownMove.badge)
	$HUD.display_text("Enemy chose: " + enemyMove.badge)
	
	if (result == "Win"):
		$HUD.display_text("You go first!");
		$HUD.enemyPokemon.damage(ownMove.damage)
		$HUD.display_text("Enemy " + str(ownMove.damage) + " damage");
		yield(get_tree().create_timer(2.0), "timeout")
		$HUD.display_text("You took " + str(enemyMove.damage) + " damage");
		$HUD.ownPokemon.damage(enemyMove.damage)
	elif (result == "Lost"):
		$HUD.display_text("Enemy goes first!");
		$HUD.display_text("You took " + str(enemyMove.damage) + " damage");
		$HUD.ownPokemon.damage(enemyMove.damage)
		yield(get_tree().create_timer(2.0), "timeout")
		$HUD.display_text("Enemy " +  str(ownMove.damage) + " damage");
		$HUD.enemyPokemon.damage(ownMove.damage)
	else:
		$HUD.display_text("It was a tie!");
		$HUD.display_text("No damage is dealt!");

func random_move():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomNumber = rng.randi_range(0, 2)
	if (randomNumber == 0):
		return "Nuzzle"
	elif (randomNumber == 1):
		return "Tackle"
	elif (randomNumber == 2):
		return "Scratch"

func rock_paper_scissor_result(ownBadge, enemyBadge):
	if (ownBadge == enemyBadge):
		return "Tie"
	elif (ownBadge == "None"):
		return "Lost"
	elif (enemyBadge == "None"):
		return "Win"
	elif (ownBadge == "Paper" && enemyBadge == "Rock"):
		return "Win"
	elif (ownBadge == "Scissor" && enemyBadge == "Paper"):
		return "Win"
	else:
		return "Lost"
