package main

import "vendor:directx/d3d11"
import rl "vendor:raylib"

arrow_states :: enum{
	Aiming,
	Flying,
	Hit,
}

arrow :: struct{
	pos: rl.Vector2,
	scale : f32,
	speed : f32,
	arrow_state : arrow_states,
	hit_offset : f32,
}

draw_arrow :: proc(arrow : arrow) {
	// head: tip at the pivot
	rl.DrawTriangle(rl.Vector2{0, 0} * arrow.scale + arrow.pos , rl.Vector2{-19, -6} * arrow.scale + arrow.pos, rl.Vector2{-19, 6} * arrow.scale + arrow.pos, rl.BLACK)

	// shaft: from x = -222 to x = -19, 4 thick
	rl.DrawRectangleV(rl.Vector2{-222, -2} * arrow.scale + arrow.pos, rl.Vector2{203, 4} * arrow.scale, rl.BLACK)

	// top feather: parallelogram as two triangles
	rl.DrawTriangle(rl.Vector2{-214, 0} * arrow.scale + arrow.pos, rl.Vector2{-223, -9} * arrow.scale + arrow.pos, rl.Vector2{-231, -9} * arrow.scale + arrow.pos, rl.BLACK)
	rl.DrawTriangle(rl.Vector2{-214, 0} * arrow.scale + arrow.pos, rl.Vector2{-231, -9} * arrow.scale + arrow.pos, rl.Vector2{-222, 0} * arrow.scale + arrow.pos, rl.BLACK)

	// bottom feather: mirrored (y flipped, point order reversed)
	rl.DrawTriangle(rl.Vector2{-214, 0} * arrow.scale + arrow.pos, rl.Vector2{-222, 0} * arrow.scale + arrow.pos, rl.Vector2{-231, 9} * arrow.scale + arrow.pos, rl.BLACK)
	rl.DrawTriangle(rl.Vector2{-214, 0} * arrow.scale + arrow.pos, rl.Vector2{-231, 9} * arrow.scale + arrow.pos, rl.Vector2{-223, 9} * arrow.scale + arrow.pos, rl.BLACK)
}

arrow_collision_shape :: proc(arrow : arrow) -> rl.Rectangle{
	return rl.Rectangle{x = arrow.pos.x - 20 * arrow.scale, y= arrow.pos.y - 2 * arrow.scale, width = 1 * arrow.scale, height = 4 * arrow.scale}
}

arrow_shoot :: proc(arrow : ^arrow){
	arrow.speed = 1000
	arrow.pos.x += arrow.speed * rl.GetFrameTime()
}