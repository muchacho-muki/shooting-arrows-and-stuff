package main

import fmt "core:fmt"
import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 450, " ")
    defer rl.CloseWindow()

    score:int = 0

    player_arrow:= arrow{
    	pos = rl.Vector2{400, 225},
    	scale = 0.8,
    	speed = 400.0,
    	arrow_state = .Aiming
    }

    arrow_oscillator:= oscillatior{
    	pos = player_arrow.pos,
    	highest = 0.0,
    	lowest = 450.0,
    	speed = 250.0,
    	dir = 1,
    	visible = true,
    }

    oscillatior_crosshair:= arrow{
    	pos = arrow_oscillator.pos,
    	scale = player_arrow.scale,
    }

    main_target := target{
    	pos = rl.Vector2{780,225},
    	size = rl.Vector2{10,100},
    }

    for !rl.WindowShouldClose() {

    	//input, i will make changes later
    	input(&player_arrow,&arrow_oscillator)
    	board, bullseye : rl.Rectangle = make_target(main_target)

    	//attaching oscillator to the crosshair
    	oscillatior_crosshair.pos.y = arrow_oscillator.pos.y

        rl.BeginDrawing()

        //arrow movemnt and draw
        oscillatior_move(&arrow_oscillator, &oscillatior_crosshair)
        draw_arrow(&player_arrow)

        //target and collisions
        draw_target(board, bullseye)
        collisions(arrow_collision_shape(player_arrow), board, bullseye,&player_arrow.arrow_state, &score)

        //showing score
        rl.DrawText(fmt.ctprint("SCORE :", score),10,10,20,rl.BLACK)
        rl.ClearBackground(rl.RAYWHITE)
        rl.EndDrawing()
    }
}

collisions :: proc(player, board, bullseye : rl.Rectangle, player_state : ^arrow_states, score: ^int){
	collide_board : bool = rl.CheckCollisionRecs(player, board)
	collide_bulleye : bool = rl.CheckCollisionRecs(player, bullseye)
	if_collide : bool = collide_board || collide_bulleye

	if if_collide && player_state^ == .Flying{
		if collide_board{score^ += 1}
		if collide_bulleye{score^ += 10}
		player_state^ = .Hit
	}

	if !if_collide && player_state^ == .Hit{
		player_state^ = .Aiming
	}
}