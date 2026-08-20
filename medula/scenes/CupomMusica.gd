extends TextureRect

@export var finalPOS : Vector2 = Vector2.ZERO
@export var initialPOS : Vector2 = Vector2.ZERO
@export var duration : float = 1.5
var type = 'musica'
var delay = false
var size_tween: Tween
var position_tween: Tween
var fade_tween: Tween

func start_animation():
	scale = Vector2.ZERO
	position = initialPOS
	modulate = Color.WHITE
	size_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	size_tween.tween_property(self, "scale", Vector2.ONE, duration / 4.0)
	size_tween.finished.connect(_on_pos_tween_all_completed)
	position_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	position_tween.tween_property(self, "position", finalPOS, duration / 2.0)
	fade_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	fade_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), duration)

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
			duration = randf_range(1, 3)
		finalPOS.x -= 64
		finalPOS.y -= 64
		start_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_pos_tween_all_completed():
	print('hiii')
	if duration == 2.34241:
		get_parent().holdermusica()


func _on_Timer_timeout():
	match type:
		'lista':
			texture = load('res://medula/tex/cupom_lista.png')
	randomize()
	if duration != 2.34241:
		duration = randf_range(1, 3)
	finalPOS.x -= 64
	finalPOS.y -= 64
	start_animation()
