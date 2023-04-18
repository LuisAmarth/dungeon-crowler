cell_t = 32;
room_width = cell_t * 30;
room_height = room_width div 2;
cell_h = room_width div cell_t;
cell_v = room_height div cell_t;
grid = ds_grid_create(cell_h,cell_v);
ds_grid_clear(grid,0);
mp_grid = mp_grid_create(0,0,cell_h,cell_v,cell_t,cell_t);
randomize();
var dir = irandom(3);
var xx = cell_h div 2;
var yy = cell_v div 2;
var chances = 1;
var passos = 400;
var inimigo_max = 5;

var chao_index = 17;
norte = 1;
oeste = 2;
leste = 4;
sul = 8;

var tile_layer = layer_tilemap_get_id("WallTiles");

for(var i = 0;i < passos;i+=1){
	
		dir = irandom(3);
	
	xx+=lengthdir_x(1,dir * 90);
	yy+=lengthdir_y(1,dir * 90);
	
	xx = clamp(xx,2,cell_h - 2);
	yy = clamp(yy,2,cell_v - 2);
	
	grid[# xx,yy] = 1;
	
}

for(var xx = 0;xx < cell_h;xx++){
	for(var yy = 0;yy < cell_v;yy++){
		if(grid[# xx,yy] == 0){
			
			var norte_t = grid[# xx,yy - 1] == 0;
			var oeste_t = grid[# xx -1,yy] == 0;
			var leste_t = grid[# xx +1,yy] == 0;
			var sul_t = grid[# xx,yy +1] == 0;
			
			var tile_index = norte_t * norte + oeste_t * oeste + leste_t * leste + sul_t * sul + 1;
			
			tilemap_set(tile_layer,tile_index,xx,yy);
			
		}else if(grid[# xx,yy] ==1){
			tilemap_set(tile_layer,17,xx,yy);
		}
	}
}

for(var xx = 0;xx < cell_h;xx++){
	for(var yy = 0;yy < cell_v;yy++){
		if(grid[# xx,yy] == 0){
			instance_create_layer(xx * cell_t,yy * cell_t,"instances",obj_parede);
		}
		
		if(grid[# xx,yy] == 1){
			var x1 = xx *cell_t + cell_t / 2;
			var y1 = yy *cell_t + cell_t / 2;
			if(!instance_exists(obj_player)){
				instance_create_layer(x1,y1,"instances",obj_player);
			}
			
			if(inimigo_max > 0){
				var chances = 35;
				var dist = 130;
				if(irandom(chances) == chances and point_distance(x1,y1,obj_player.x,obj_player.y) > dist){
				instance_create_layer(x1,y1,"instances",obj_inimigo);
				inimigo_max-=1;
				}
			}
			
		}
	}
}

mp_grid_add_instances(mp_grid,obj_parede,false);