extends ProgressBar

var currentStar = 0
var currentMarieda = 0
var reachedLista = false
var score = 50000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $Tween.is_active():
		$ScoreLabel.text = str(int(value))
		
		if value >= 1000*currentMarieda:
			currentMarieda+=1
			get_parent().get_parent().get_parent().holdermusica(true)
			
		
		if value >= 9000 and currentStar == 0:
			$StarAchieve.play()
			get_node("1/anim").play("explode")
			currentStar += 1
			
			
			get_parent().get_parent().get_parent().holdermusica()
		if value >= 18000 and currentStar == 1:
			$StarAchieve.play()
			get_node("2/anim").play("explode")
			currentStar += 1
			
			
			get_parent().get_parent().get_parent().holdermusica()
		if value >= 27000 and currentStar == 2:
			$StarAchieve.play()
			get_node("3/anim").play("explode")
			currentStar += 1
			
			
			get_parent().get_parent().get_parent().holdermusica()
		if value >= 36000 and currentStar == 3:
			$StarAchieve.play()
			get_node("4/anim").play("explode")
			currentStar += 1
			
			
			get_parent().get_parent().get_parent().holdermusica()
		if value >= 45000 and currentStar == 4:
			$StarAchieve.play()
			get_node("5/anim").play("explode")
			currentStar += 1
			
			
			get_parent().get_parent().get_parent().holdermusica()
		
		
		
		if value >= 50000 and !reachedLista:
			$Riser.stop()
			get_parent().get_parent().get_parent().holdermusica(false, true)
			reachedLista = true
		
		
func score_tween():
	$Tween.interpolate_property(self, 'value', 0, global.score, 7, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.start()
	$Riser.play()


func _on_Tween_tween_all_completed():
	get_parent().get_parent().get_parent()._on_Tween_tween_all_completed()
