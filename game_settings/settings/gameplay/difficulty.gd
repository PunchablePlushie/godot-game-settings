@tool
extends ggsSetting


func apply(value: int) -> void:
	match value:
		0:
			GM.difficulty = GM.Difficulty.EASY
		1:
			GM.difficulty = GM.Difficulty.MEDIUM
		2:
			GM.difficulty = GM.Difficulty.HARD
		3:
			GM.difficulty = GM.Difficulty.NIGHTMARE
		
