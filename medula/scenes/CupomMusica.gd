extends TextureRect

export var finalPOS : Vector2 = Vector2.ZERO
export var initialPOS : Vector2 = Vector2.ZERO
export var duration : float = 1.5
var type = 'musica'
var delay = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if delay:
		$Timer.start()
	else:
		match type:
			'lista':
				texture = load('res://medula/tex/cupom_lista.png')
		randomize()
		if duration != 2.34241:
			duration = rand_range(1, 3)
		finalPOS.x -= 64
		finalPOS.y -= 64
		$size.interpolate_property(self, 'rect_scale', Vector2(0,0), Vector2(1,1), duration/4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$pos.interpolate_property(self, 'rect_position', initialPOS, finalPOS, duration/2.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$modulate_a.interpolate_property(self, 'modulate', Color(1,1,1,1), Color(1,1,1,0), duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$pos.start()
		$size.start()
		$modulate_a.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_pos_tween_all_completed():
	print('hiii')
	if duration == 2.34241:
		get_parent().holdermusica()


func _on_Timer_timeout():
	match type:
		'lista':
			texture = load('res://tex/cupom_lista.png')
	randomize()
	if duration != 2.34241:
		duration = rand_range(1, 3)
	finalPOS.x -= 64
	finalPOS.y -= 64
	$size.interpolate_property(self, 'rect_scale', Vector2(0,0), Vector2(1,1), duration/4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$pos.interpolate_property(self, 'rect_position', initialPOS, finalPOS, duration/2.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$modulate_a.interpolate_property(self, 'modulate', Color(1,1,1,1), Color(1,1,1,0), duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$pos.start()
	$size.start()
	$modulate_a.start()
