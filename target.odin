package main

import rl "vendor:raylib"

target :: struct{
	pos: rl.Vector2,
	size: rl.Vector2,
}

make_target :: proc(target: target) -> (rl.Rectangle, rl.Rectangle) {
	main_board:= rl.Rectangle{x = target.pos.x, y = target.pos.y,
	 			 height = target.size.y, width = target.size.x}

	bullseye:= rl.Rectangle{x = target.pos.x - target.size.x, y = target.pos.y + target.size.y * 0.3,
				height = target.size.y * 0.4, width = target.size.x}

	return main_board, bullseye
}

draw_target :: proc(board, bullseye : rl.Rectangle){
	rl.DrawRectangleRec(board, rl.BLACK)
	rl.DrawRectangleRec(bullseye, rl.RED)
}