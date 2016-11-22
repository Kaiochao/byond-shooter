#define TILE_WIDTH 32
#define TILE_HEIGHT 32

#include "Client.dm"
#include "Turf.dm"
#include "Player.dm"

var list/spawnpoints

world
	fps = 20

	maxx = 30
	maxy = 30

	view = 10

	turf = /turf/grass
	mob = /mob/player

	New()
		for(var/turf/grass/g)
			if(prob(5))
				for(var/turf/t in range(1, g))
					new /turf/wall (t)

		for(var/turf/grass/g)
			if(prob(5)) new /mob/target (g)
			if((g.x + g.y) % 2) g.color = rgb(0, 100, 0)
			else g.color = rgb(0, 105, 0)

		for(var/turf/wall/w)
			if((w.x + w.y) % 2) w.color = rgb(100, 100, 100)
			else w.color = rgb(105, 105, 105)

		var list/grasses = new
		for(var/turf/grass/g) grasses += g

		spawnpoints = new (10)
		for(var/n = 1 to spawnpoints.len)
			var g = pick(grasses)
			spawnpoints[n] = g
			grasses -= g
