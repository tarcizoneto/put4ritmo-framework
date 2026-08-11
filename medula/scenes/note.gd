extends TextureButton

var currentEvent = 0
var time = 0
var row = 0
var dur = 0
var feedbackNow = 0
var timetonext = 0
var active = true
var perdeu = false
var isAnotherNoteOver = 0

func _ready():
	$Tween.interpolate_property(self, 'rect_position', Vector2(0,0), Vector2(0,1845), time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	if timetonext >0:
		if ! global.database[global.codename].hard:
			rect_scale.y = .5
			print('loww')

# Called when the node enters the scene tree for the first time.
func setup():
	$duration.rect_size.y = dur
	$duration.rect_size.x = self.rect_size.x/3
	$duration.rect_position.y = -dur
	$duration.rect_position.x = rect_size.x/2 - $duration.rect_size.x/2


func _on_Area2D_area_entered(area):
	if area.name == 'note' and !$AnimationPlayer.is_playing():
		if ! global.database[global.codename].hard:
			if isAnotherNoteOver == 0:
				isAnotherNoteOver = 1
			else:
				isAnotherNoteOver = 0
				rect_scale.y = 0.75
	if area.name == 'good':
		feedbackNow = 0.5
	elif area.name == 'perf':
		feedbackNow = 1
		if global.BOT:
			on_TouchScreenButton_pressed()
	
	#$Label.text = str(feedbackNow)


func _on_Area2D_area_exited(area):
	if area.name == 'perf' and active:
		feedbackNow = 0
	#$Label.text = str(feedbackNow)





func _on_AnimationPlayer_animation_finished(anim_name):
	#lost()
	pass

func lost():
	$AnimationPlayer.play("fail")
	$Tween.interpolate_property(self, 'rect_position', rect_position, Vector2(360-rect_size.x,780-rect_size.y/2), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	

#henrique tava escutando musica de c1r se amostrando aqui no quarto 21/08/22
#c1r é cumplices de um resgate ! kkkkkkkk 23/02/23
#mds como eu era besta viu 29/12/2023
#estou de voltaaa 20/03/24
# e agora com o buva amooo 12/07/2024

	#pra ver se 
	#print('cooollaaaaaaa')
	#print(get_parent().get_parent().name)


func on_TouchScreenButton_pressed():
	if active:
		$Tween.stop_all()
		if feedbackNow == 1:
			get_parent().get_parent().get_parent().perfect()
			$AnimationPlayer.play("perfect")
		if feedbackNow == .5:
			get_parent().get_parent().get_parent().good()
			$AnimationPlayer.play("good")
		if feedbackNow == 0:
			lost()
		if global.score + global.feedback*feedbackNow < 50000:
			global.score += global.feedback*feedbackNow
		else:
			global.score = 50000
	active = false

func _input(event):
	if feedbackNow != 0:
		if event.is_action_pressed("ui_left") and row == 0:
			on_TouchScreenButton_pressed()
		if event.is_action_pressed("ui_down") and row == 1:
			on_TouchScreenButton_pressed()
		if event.is_action_pressed("ui_right") and row == 2:
			on_TouchScreenButton_pressed()


func _on_Area2D_mouse_entered():
	on_TouchScreenButton_pressed()

func pause():
	pass
	
func resume():
	pass

func usedTotem():
	_ready()

func _on_TouchScreenButton_pressed():
	on_TouchScreenButton_pressed()


func _on_Tween_tween_all_completed():
	if active:
		lost()
		active = false
	else:
		if ! perdeu:
			perdeu = true
			get_parent().get_parent().get_parent().lost(currentEvent)
			print('calmo caralho')
