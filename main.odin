package main

import fmt "core:fmt"
import rl "vendor:raylib"
import rand "core:math/rand"

just_hit: bool
no_of_ammo: int

game_state :: enum{
    Start,
    Run,
    End
}

main :: proc() {
    rl.InitWindow(800, 450, " ")
    defer rl.CloseWindow()

    state : game_state = .Start

    score:int = 0
    no_of_ammo = 12
    ammo : [dynamic]arrow

    make_ammo(rl.Vector2{15,30},&ammo)

    player_arrow:= arrow{
    	pos = rl.Vector2{200, 225},
    	scale = 0.8,
    	speed = 1000.0,
    	arrow_state = .Aiming
    }

    arrow_oscillator:= oscillatior{
    	pos = player_arrow.pos,
    	highest = 30.0,
    	lowest = 420.0,
    	speed = 400.0,
    	state = .Oscillating,
        up= true,
    	visible = true,
    }

    oscillator_crosshair:= arrow{
    	pos = arrow_oscillator.pos,
    	scale = player_arrow.scale,
    }

    main_target := target{
    	pos = rl.Vector2{780,225},
    	size = rl.Vector2{10,100},
    }

    target_oscillator := oscillatior{
        pos = main_target.pos,
        highest = 10.0,
        lowest = 350.0,
        speed = 150.0,
        visible = true,
        state = .Random,
        up = false,
        target_pos = main_target.pos,
    }

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

    	switch state{
            case .Start:    score = 0
                            no_of_ammo = 12
                            Start_screen(&state)
                            arrow_oscillator.speed = 400.0
                            target_oscillator.state = .Random
                            target_oscillator.target_pos = rl.Vector2{780,225}
                            player_arrow.pos = arrow_oscillator.pos

            case .Run:  set_difficulty(score,&target_oscillator, &arrow_oscillator)
                        input(&player_arrow,&arrow_oscillator)
                        board, bullseye : rl.Rectangle = make_target(main_target)

        //attaching oscillator
                        oscillator_crosshair.pos.y = arrow_oscillator.pos.y
                        main_target.pos.y = target_oscillator.pos.y

                        if player_arrow.arrow_state == .Hit{player_arrow.pos.y = main_target.pos.y + player_arrow.hit_offset}

        //--------------------------------------------------everything draw related----------------------------------------------//

        //draw ammo
                        display_ammo(ammo)

        //arrow movemnt and draw
                        handle_oscillatior(&arrow_oscillator)
                        handle_oscillatior(&target_oscillator)
                        if arrow_oscillator.visible{ draw_arrow(oscillator_crosshair)}
                        draw_arrow(player_arrow)

        //target and collisions
                        draw_target(board, bullseye)
                        state_before : arrow_states = player_arrow.arrow_state
                        collisions(arrow_collision_shape(player_arrow), board, bullseye,&player_arrow.arrow_state, &score)
                        just_hit = state_before == .Flying && player_arrow.arrow_state == .Hit

                        if just_hit{
                            player_arrow.hit_offset = player_arrow.pos.y - main_target.pos.y
                        }

        //showing score
                        rl.DrawText(fmt.ctprint("SCORE :", score),10,10,20,rl.BLACK)

                        if no_of_ammo<=0 && player_arrow.arrow_state != .Flying{state = .End}

            case .End:  End_screen(&state, score)
        }

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
}