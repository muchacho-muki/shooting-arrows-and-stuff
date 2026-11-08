package main

import rl "vendor:raylib"
import fmt "core:fmt"

make_ammo :: proc(pos:rl.Vector2, list: ^[dynamic]arrow){
	offset:f32= 0
	for i in 0..<no_of_ammo + 1{
		append(list, arrow{pos = rl.Vector2{pos.x, pos.y + offset}, scale = 0.5})
		offset += 10.0
	}
}

display_ammo :: proc (list: [dynamic]arrow){
	for i in 0..<no_of_ammo{
		draw_arrow(list[i])
	}
}

set_difficulty :: proc(score:int, osc:^oscillatior, player: ^oscillatior){
	if score > 40{
		player.speed = 500
	}
	if score >= 70{
		osc.speed = 400
		osc.state = .Oscillating
	}
}

Start_screen :: proc(state: ^game_state){
	rl.DrawText("press Enter to play :)",400,225,30,rl.BLACK)
	if rl.IsKeyPressed(.ENTER){
		state^ = .Run
	}
}

End_screen :: proc(state: ^game_state, score:int){
	rl.DrawText(fmt.caprint("you scored :", score),100,225,30,rl.BLACK)
	if rl.IsMouseButtonPressed(.LEFT){
		state^ = .Start
	}
}