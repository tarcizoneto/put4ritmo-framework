extends ColorRect

var startTime = 0
var delay = 0


func _ready():
	$Timer.start()



func _on_Timer_timeout():
	$AnimationPlayer.play("tick")
	$Met.play()
	startTime = Time.get_ticks_msec()
	print(startTime)
	$Timer.start()


func _on_Button_pressed():
	$AnimationPlayer.play("tick")
	delay = Time.get_ticks_msec() - startTime - 138
	$Delay.text = str(delay) + ' ms'


func _on_Back_pressed():
	global.delay = delay
	queue_free()
