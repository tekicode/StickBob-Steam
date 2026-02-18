background_map = ds_map_create();
background_map[? layer_get_id("bgClouds")] = 0.3;
background_map[? layer_get_id("bgDistantGround")] = 0.2;
background_map[? layer_get_id("bgNearGround")] = 0.1;
background_map[? layer_get_id("bgGroundPath")] = 0;
background_map[? layer_get_id("bgForeground")] = -0.5;