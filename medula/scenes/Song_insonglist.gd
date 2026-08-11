extends ColorRect

var codename = ''

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = global.database[codename].Title
	$Artist.text = global.database[codename].Artist
	$Cover.texture = load(global.returnpath('cover', codename))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_parent().get_parent().get_parent().get_parent().songlistSelected(codename)
