package main

import fmt "core:fmt"
import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 450, " ")
    defer rl.CloseWindow()

    //set to 80 because its cooler than 60
    rl.SetTargetFPS(60)
    score:int = 0

    oscillatior_y : f32 = 225
    oscillator_vis : bool = true
    arrow_pos := rl.Vector2{400,225}
    was_arrow_shot := false
    arrow_hit := false

    for !rl.WindowShouldClose() {
    	input(&arrow_pos, &was_arrow_shot,&arrow_hit, &oscillator_vis)
    	if !was_arrow_shot {arrow_pos.y = oscillatior_y}
    	// arrow_oscillation(&arrow_pos,0.0,450,5)
        rl.BeginDrawing()
        oscillatior(&oscillatior_y,0,450,10, oscillator_vis)
        draw_arrow(arrow_pos)
        // rl.DrawRectangleRec(arrow_collision_shape(arrow_pos), rl.RED)
        rl.DrawRectangleRec(make_target(), rl.RED)
        collisions(arrow_collision_shape(arrow_pos), make_target(), &score)
        rl.ClearBackground(rl.RAYWHITE)
        rl.DrawText(fmt.ctprint("SCORE :", score),10,10,20,rl.BLACK)
        // rl.DrawFPS(10, 10)
        rl.EndDrawing()
    }
}

input :: proc (pos:^rl.Vector2, shoot:^bool, hit:^bool, osc_vis :^bool) {
	// if !shoot^ {arrow_oscillation(pos,0.0,450,5)}
	if rl.IsKeyPressed(.SPACE) || rl.IsMouseButtonPressed(.LEFT){
		shoot^ = true
		osc_vis^ = false
	}

	if shoot^ {
		arrow_shoot(pos)
	}

	if pos.x > 1000{
		shoot^ = false
		osc_vis^ = true
		hit^ = true
	}

	if hit^{
		hit^ = false
		pos.x = 400.0
	}
}

collisions :: proc(rec1,rec2 : rl.Rectangle, score: ^int){
	@(static) was_colliding : bool = false
	if_collide : bool = rl.CheckCollisionRecs(rec1, rec2)

	if if_collide && !was_colliding{
		score^ += 1
		was_colliding = true
	}

	if !if_collide && was_colliding{
		was_colliding = false
	}
}