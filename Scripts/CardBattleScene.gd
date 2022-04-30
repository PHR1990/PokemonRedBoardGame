extends Node

onready var dictionary = load("res://Scripts/DataDictionary.gd").new()

var enemyPokemonName = "Arcanine"

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.display_enemy_card(enemyPokemonName)
	$HUD.switch_own_pokemon("Charmander")
	
	$HUD.connect("change_pokemon_card_pressed", self, "_change_card")
	$HUD.connect("move_card_was_pressed", self, "_move_card_pressed")


func _change_card(position):
	if position == 1:
		$HUD.switch_own_pokemon("Poliwag")
	elif position == 2:
		$HUD.switch_own_pokemon("Vulpix")
	else:
		$HUD.switch_own_pokemon("Jigglypuff")
		
func _move_card_pressed(moveName):
	$HUD.reset_label()
	var ownMove = dictionary.moves.get(moveName)
	var enemyMove = dictionary.moves.get(random_move())
	
	var result = rock_paper_scissor_result(ownMove.badge, enemyMove.badge)
	
	$HUD.display_text("You choose: " + ownMove.badge)
	$HUD.display_text("Enemy chose: " + enemyMove.badge)
	
	$HUD.enemyPokemon.consume_affinity(enemyMove.cost)
	
	if "recover" in enemyMove:
		$HUD.enemyPokemon.recover_affinity(enemyMove.recover)
	print(ownMove)
	if "recover" in ownMove:
		print("recovering")
		$HUD.ownPokemon.recover_affinity(ownMove.recover)
	
	$HUD.ownPokemon.consume_affinity(ownMove.cost)
	
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
	
	var movesList = dictionary.pokemon.get(enemyPokemonName).Moves
	var randomNumber = rng.randi_range(0, len(movesList)-1)
	
	print(movesList[randomNumber])
	return movesList[randomNumber]
	

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
