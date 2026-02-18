var hcells = ceil (room_width/cell_width);
var vcells = ceil (room_height/cell_width);
global.ds_grid_pathfinding = ds_grid_create(hcells, vcells);
for(var i=0; i<hcells; i+=1){
	for(var j = 0; j<vcells; j+=1){
		if place_meeting(i*cell_width,j*cell_height,objSolid){
			ds_grid_add(global.ds_grid_pathfinding,i,j,-2)
		}
		else{
			ds_grid_add(global.ds_grid_pathfinding,i,j,-1)	
		}
	}
			
}
	 