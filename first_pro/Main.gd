extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	pass

func game_over():
	$Music.stop()
	$DeathSound.play()
	print('游戏结束')
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	$Music.play()
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mod_timer_timeout():
	# 创建一个敌人实例
	var mob = mob_scene.instantiate()
	# 从Path2D上随机选取一个点对象，randf()返回一个浮点数0.0-1.0，progress_ratio为路径偏移量，长度乘百分比
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	# 设置随机位置
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	# 设置敌人的随机运动方向。即垂直于边框，再加上一点随机
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# 设置敌人速度
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# 添加敌人对象到主场景
	add_child(mob)
