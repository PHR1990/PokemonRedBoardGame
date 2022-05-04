extends Node2D

signal card_used(moveName)

export var moveName = ""
export var damageAmount = 0
export var affinityCostAmount = 0
export var type = "Normal"
export var badge = "Rock"

# Called when the node enters the scene tree for the first time.
func _ready():
	$nameLabel.text = moveName
	$damageLabel.text = str(damageAmount)
	$affinityCostLabel.text = str(affinityCostAmount)
	$type.texture = load("res://Assets/Types/" + type + ".png")
	$badge.texture = load("res://Assets/Badges/" + badge + ".png")
	

func _on_Button_pressed():
	emit_signal("card_used", moveName)
	


func _on_Button_mouse_exited():
	self.set_scale(Vector2(1,1))
	self.set_z_index(0)


func _on_Button_mouse_entered():
	self.set_scale(Vector2(1.25,1.25))
	self.set_z_index(1)
