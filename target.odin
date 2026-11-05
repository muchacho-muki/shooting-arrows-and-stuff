package main

import rl "vendor:raylib"

make_target :: proc() -> rl.Rectangle {
	return rl.Rectangle{x = 700, y = 225, height = 30 , width = 10}
}