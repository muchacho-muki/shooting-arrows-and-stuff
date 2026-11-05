package main

import rl "vendor:raylib"

oscillatior :: proc(oscillatior_y : ^f32, highest,lowest,speed:f32 , vis:bool){
	if vis{	draw_arrow(rl.Vector2{400, oscillatior_y^})}
	@(static)direction:f32= 1
	oscillatior_y^ += speed * direction
	// if shoot && !hit{direction = 0} else {pos.y = highest}
	if oscillatior_y^ <= highest {oscillatior_y^ = highest; direction = 1}
	if oscillatior_y^ >= lowest {oscillatior_y^ = lowest; direction = -1}
}