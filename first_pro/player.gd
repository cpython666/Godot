extends Area2D

signal hit

# 玩家移动速度
@export var speed = 400
# 屏幕尺寸
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	print(screen_size)

func _process(delta):
	# 玩家的移动向量
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		# 归一化处理
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	# 如果x轴速度不是0的话，播放行走动画，
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		# 防止上下移动后垂直翻转的状态保留
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0                                   
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func start(pos):
	# 显示玩家，显示刚体
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	# 被撞后隐藏玩家，提交撞击信号
	print('被撞了')
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
