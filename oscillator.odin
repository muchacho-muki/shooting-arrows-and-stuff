package main

import rl "vendor:raylib"
import rand "core:math/rand"

osc_states :: enum{
	Random,
	Oscillating
}

oscillatior :: struct {
	pos: rl.Vector2,
	highest: f32,
	lowest: f32,
	speed: f32,
	target_pos: rl.Vector2,
	state : osc_states,
	up: bool,
	visible: bool,
}

oscillatior_move :: proc(osc : ^oscillatior){
	osc.pos = rl.Vector2MoveTowards(osc.pos, osc.target_pos, osc.speed * rl.GetFrameTime())
}

oscillatior_randomizer :: proc(osc: ^oscillatior){
	osc.speed = 1000
	osc.target_pos = rl.Vector2{osc.pos.x,rand.float32_range(osc.highest, osc.lowest)}
}

oscillatior_oscillating :: proc(osc: ^oscillatior){

	if osc.pos == osc.target_pos{
		osc.up = !osc.up
	}

	if osc.up{
		osc.target_pos.y = osc.highest
	}else{
		osc.target_pos.y = osc.lowest
	}
}

handle_oscillatior :: proc(osc: ^oscillatior){
	oscillatior_move(osc)

	switch osc.state{
		case .Random: if just_hit {oscillatior_randomizer(osc)}

		case .Oscillating: oscillatior_oscillating(osc)
	}
}