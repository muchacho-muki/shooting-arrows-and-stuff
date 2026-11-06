package main

import rl "vendor:raylib"

input :: proc (player: ^arrow, osc: ^oscillatior) {

	input_detect: bool = rl.IsKeyPressed(.SPACE) || rl.IsMouseButtonPressed(.LEFT)
	out_of_boundry : bool = player.pos.x > 1000

	switch player.arrow_state{
		case .Aiming: 
			reset_and_reaiming(player,osc)
		 	if input_detect {
				player.arrow_state = .Flying}

		case .Flying: arrow_shoot(player);
					  osc.visible = false;

		case .Hit: osc.visible = true;
				   player.speed = 0.0;
				   if input_detect {
				   	reset_and_reaiming(player,osc)
				   	player.arrow_state = .Flying
				   }
	}

	if out_of_boundry{
		player.pos.x = 400
		player.arrow_state = .Aiming
	}
}

reset_and_reaiming :: proc(player: ^arrow, osc: ^oscillatior){
	player.pos.x = 400
	player.pos.y = osc.pos.y;
}