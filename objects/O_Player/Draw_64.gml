draw_set_color(c_red); // Set the text color to white
draw_set_halign(fa_left); // Align text to the left
draw_set_valign(fa_top); // Align text to the top
draw_text(10, 15, "xSpeed: " + string(xSpeed));
draw_text(10, 30, "ySpeed: " + string(ySpeed));
draw_text(10, 45, "xInput: " + string(xInput));
draw_text(10, 60, "yInput: " + string(yInput));
draw_text(10, 75, "wallJump: " + string(wallJump));
draw_text(10, 90, "wallJumpTimer: " + string(cwjt));
draw_text(10, 105, "canJump: " + string(canJump));
draw_text(10, 120, "isCrawling: " + string(isCrawling));
draw_text(10, 135, "fallCooldown: " + string(fallCooldown));
draw_text(10, 150, "collisionAngle: " + string(collisionAngle));