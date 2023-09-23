## 前言
大家好，这一集我将要带领大家完成官方文档里的第一个2DGodot游戏，从零开始，逐步解析，演示游戏的制作全过程，尽量让，就算是新入坑的兄弟也能流畅清晰地完成这个项目。
之所以做这个视频是因为，有些才入门学习的兄弟在自己看文档学习的过程中，难免会有一些暂时疑惑，懵懵懂懂的地方，有时候如果少看了文档中某一步骤或者细节，后面再逐步找错是非常麻烦的。
所以在这个视频中，这个游戏制作的思路，代码作用，我会尽量都讲一下，将大家的疑惑最小化。
同时，基于Godot4.1的这个游戏的完整的项目文件和游戏素材都可以在我的项目仓库或者是共享群文件中都可以找到。
![image.png](https://cdn.nlark.com/yuque/0/2023/png/38536969/1695030732642-7c5cad39-92b1-4675-9000-cea2c0388431.png#averageHue=%23edd197&clientId=u573c60b5-4035-4&from=paste&height=773&id=n1AKz&originHeight=966&originWidth=1921&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=139353&status=done&style=none&taskId=u4b633d01-ebac-435e-8f53-2a28734dfd8&title=&width=1536.8)	首先我们来看一下游戏的效果：

下面我们开始项目的讲解：
## 思路讲解
首先，我们需要知道我们要做的游戏，并且理清楚游戏的思路。
游戏就是简单的躲避游戏，控制我们的小人在屏幕中运动，躲避随机生成的敌人，如果碰到了敌人，那我们就输了，游戏的分数就是我们的生存时间，时间越久分数越高。
好了，游戏的思路就是这么简单，但我们做出这个游戏只有这些大白话描述的规则肯定是远远不够的。我们要将其转化为方便我们做出游戏程序的语言，也就是分析出游戏中包含的模块，对象及其功能。
那么我们的游戏可以分析拆分出什么呢？
根据文档中的思路，我们将其拆分为以下几部分：
主场景，敌人场景，玩家场景，平视显示器HUD，
并且我整理出每个场景我们需要做的事情，如下：
项目设置：窗口大小：480，720
主场景（Main）：

      - 新建Node节点命名为Main
      - 实例化子场景player命名为Player
      - 添加三个计时器Timer，分别命名为MobTimer，ScoreTimer，StartTimer，时间分别设置为0.5，1，2s,StartTimer设置为仅播放一次，其他默认无限播放
      - 新建AudioStreamPlayer2D，命名为DeathSound，阵亡时播放的音乐
      - 新建AudioStreamPlayer2D，命名为Music，作为bgm，Looping设置为启用
      - 新建Maker2D，命名为StartPosition，将position改为240，450
      - 新建Path2D，将其命名为MobPath，在窗口四边为其添加路径，添加子节点PathFollow2D将其命名为MobSpawnLocation
      - 新建ColorRect，设置背景颜色，层级后移
      - 实例化子场景hud命名为HUD
      - 绑定脚本，联系多个场景组件
         - 游戏开始，结束对应操作
         - 设置敌人随机出现运动
         - 定义一些函数

敌人（Mob）：

      - 新建RigidBody2D，命名为Mob，修改重力缩放为0
      - 添加子节点AnimatedSprite2D，并为其设置fly，walk，swim动画帧
      - 设置碰撞区域CollisionShape2D，调整其形状大小与图片吻合，取消mask层，避免敌人间相互碰撞
      - 命名对象组
      - 按照喜好设置缩放比
      - 绑定脚本

玩家（Player）：

      - 新建Area2D，命名为Player
      - 新建AnimatedSprite2D，设置up与walk动画
      - 新建碰撞区域CollisionShape2D，调整大小
      - 根据喜好设置合适的缩放比
      - 绑定脚本
         - 设置上下左右映射
         - 速度归一化
         - 设置碰撞函数回调，碰撞信号

平视显示器（HUD）
> 这是一种信息显示，显示为游戏视图顶部的叠加层。
> CanvasLayer 节点允许我们在游戏其余部分上方的图层上绘制 UI 元素，这样它显示的信息就不会被任何游戏元素（如玩家或生物）所掩盖。

      - 新建CanvasLayer命名为HUD
      - 新建Label，命名为ScoreLabel，上中，设置字体及大小，用于显示分数
      - 新建Label，命名为Message，居中，用于显示一些信息
      - 新建Button，命名为StartButton，中下，用于点击触发函数开始游戏再来一次
      - 新建Timer，命名为MessageTimer，消息显示的倒计时
      - 添加脚本

接着我们准备游戏素材，直接文档中下载，然后拖进我们的项目文件夹。

反派在文档中将其命名为mob/mɑːb/，我们查询了一下翻译，是这个意思，不知道大家会不会享受这种顺便背单词的感觉，当然，你可以将它命名为任何你喜欢的名字。在这里，我们和文档保持一致，就命名为mob。
![image.png](https://cdn.nlark.com/yuque/0/2023/png/38536969/1694952492113-ffec187f-ddb5-40e1-a00f-a6ee4ee3903c.png#averageHue=%23edf1f9&clientId=u5b61a63f-d46f-4&from=paste&height=457&id=u8e4cbc54&originHeight=571&originWidth=1065&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=124342&status=done&style=none&taskId=uf465bfb8-637b-4beb-93bd-7c89e20d20c&title=&width=852)

## 代码
### Player.gd
```python
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
```
### Mob.gd
```python
extends RigidBody2D

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

func _on_visible_on_screen_notifier_2d_screen_exited():
	# 安全删除对象
	queue_free()
```
### HUD.gd
```python
extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	# 显示文本并且开启消息计时器
	show_message("游戏结束！")
	# 等待消息计时器结束
	await $MessageTimer.timeout

	$Message.text = "躲避坏蛋！"
	$Message.show()
	# 创建一个一秒的延迟
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
```
### Main.gd
```python
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
```
```python
extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	# 显示文本并且开启消息计时器
	show_message("游戏结束！")
	# 等待消息计时器结束
	await $MessageTimer.timeout

	$Message.text = "躲避坏蛋！"
	$Message.show()
	# 创建一个一秒的延迟
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

```

注意将信号与方法联系起来，每个场景之中的节点信号与方法，还有两个就是start_game信号与hit信号分别对应的开始游戏与结束游戏。
