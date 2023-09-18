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
