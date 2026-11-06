package main

import rl "vendor:raylib"

oscillatior :: struct {
	pos: rl.Vector2,
	highest: f32,
	lowest: f32,
	speed: f32,
	dir: f32,
	visible: bool,
}

oscillatior_move :: proc(osc : ^oscillatior, crosshair: ^arrow){
	if osc.visible{	draw_arrow(crosshair)}
	osc.pos.y += osc.speed * osc.dir * rl.GetFrameTime()
	// if shoot && !hit{direction = 0} else {pos.y = highest}
	if osc.pos.y <= osc.highest {osc.pos.y = osc.highest; osc.dir = 1}
	if osc.pos.y >= osc.lowest {osc.pos.y = osc.lowest; osc.dir = -1}
}