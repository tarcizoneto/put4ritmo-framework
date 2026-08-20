extends TextureButton

@export var noteName : String
@export var price : int
var bought = false
var easter = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.customNote != noteName:
		$Selected.hide()
	$CustomNote.texture = load("res://medula/tex/custom/notes/"+noteName+".png")
	$Price.text = str(price)
	if price == 3634:
		$Price.text = 'Apenas em baús'
		$IconPrice.visible = false
		$Price.modulate = '#00ff00'
		easter = true
	if ! noteName in global.customNotesBought:
		$CustomNote.modulate = '#494949'
		$AnimationPlayer.stop()
		
	else:
		$IconPrice.hide()
		$ColorRect.hide()
		$Price.hide()
		bought = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.customNote != noteName:
		$Selected.hide()
	else:
		$Selected.show()
#

func _on_ShopNote_pressed():
	print(bought)
	
	if global.mariedas >= price and ! bought and ! easter:
		global.mariedas -= price
		global.addProgressTask('spend', price)
		global.customNotesBought.append(noteName)
		$CustomNote.modulate = "#ffffff"
		$AnimationPlayer.play("disabled")
		$IconPrice.hide()
		$ColorRect.hide()
		$Price.hide()
		bought = true
		global.customNote = noteName
		$Selected.show()
		$Selected/AnimationPlayer.play("select")
		get_parent().get_parent().get_parent().get_parent().get_node("Buy").play()
		global.store_save()
	elif global.mariedas < price and !bought and ! easter:
		$Shine.play("shine")
	if bought:
		global.customNote = noteName
		$Selected.show()
		$Selected/AnimationPlayer.play("select")
		global.store_save()
		get_parent().get_parent().get_parent().get_parent().get_parent().reloadInfo(false)
	print(bought)
	print(global.customNote)
	print(noteName)
