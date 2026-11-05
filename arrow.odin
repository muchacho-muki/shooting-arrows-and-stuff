package main

import "vendor:directx/d3d11"
import rl "vendor:raylib"

arrow :: struct{
	pos: rl.Vector2,
	scale : f32,
	was_shot : bool,
	hit_something : bool,
}

draw_arrow :: proc(pos: rl.Vector2) {
	// head: tip at the pivot
	rl.DrawTriangle(rl.Vector2{0, 0} + pos, rl.Vector2{-19, -6} + pos, rl.Vector2{-19, 6} + pos, rl.BLACK)

	// shaft: from x = -222 to x = -19, 4 thick
	rl.DrawRectangleV(rl.Vector2{-222, -2} + pos, rl.Vector2{203, 4}, rl.BLACK)

	// top feather: parallelogram as two triangles
	rl.DrawTriangle(rl.Vector2{-214, 0} + pos, rl.Vector2{-223, -9} + pos, rl.Vector2{-231, -9} + pos, rl.BLACK)
	rl.DrawTriangle(rl.Vector2{-214, 0} + pos, rl.Vector2{-231, -9} + pos, rl.Vector2{-222, 0} + pos, rl.BLACK)

	// bottom feather: mirrored (y flipped, point order reversed)
	rl.DrawTriangle(rl.Vector2{-214, 0} + pos, rl.Vector2{-222, 0} + pos, rl.Vector2{-231, 9} + pos, rl.BLACK)
	rl.DrawTriangle(rl.Vector2{-214, 0} + pos, rl.Vector2{-231, 9} + pos, rl.Vector2{-223, 9} + pos, rl.BLACK)
}

arrow_collision_shape :: proc(pos:rl.Vector2) -> rl.Rectangle{
	return rl.Rectangle{x = pos.x - 220 , y= pos.y - 2 , width = 203, height = 4}
}

arrow_shoot :: proc(pos : ^rl.Vector2){
	pos.x += 20.0
}