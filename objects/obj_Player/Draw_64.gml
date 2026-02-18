draw_set_color(c_red); // Set the text color to white
draw_set_halign(fa_left); // Align text to the left
draw_set_valign(fa_top); // Align text to the top
draw_text(10, 10, "xSpeed: " + string(xSpeed));
draw_text(10, 20, "ySpeed: " + string(ySpeed));
draw_text(10, 30, "xInput: " + string(xInput));
draw_text(10, 40, "yInput: " + string(yInput));
draw_text(10, 50, "yInput: " + string(sprite_index));
draw_text(10, 60, "canSlide: " + string(canSlide));
draw_text(10, 70, "canJump: " + string(canJump));
draw_text(10, 80, "isCrawling: " + string(isCrawling));
draw_text(10, 90, "fallCooldown: " + string(fallCooldown));
draw_text(10, 100, "collisionAngle: " + string(collisionAngle));