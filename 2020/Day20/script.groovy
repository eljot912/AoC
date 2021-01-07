def get_input() {

    File file = new File('Day20/input')
    input=file.text.replace('\r','').split('\n\n')
    outputMap=[:]
    for (tile in input) {
        List t = tile.split('\n')
        int tileID = Integer.parseInt(t[0][-5..-2])
        outputMap[tileID] = t[1..-1]
    }
    return outputMap
}

def get_border(tileArray,edge) {
	String border = ''
	switch(edge) {
		case 'n':
			border = tileArray[0]
			break
		case 's':
			border = tileArray[-1]
			break
		case 'e':
			border = (tileArray.collect { it[-1] }).join()
			break
		case 'w':
			border = (tileArray.collect { it[0] }).join()
	}
	return border
}


def match_puzzles(tilesMap) {
    matchSide = [:]
    cornersMap = [:]
    tileCombos = [tilesMap.keySet(),tilesMap.keySet()].combinations().findAll{a,b-> a <b}
	//println tileCombos.size()
	for (ids in tileCombos) {
		(id_1, id_2) = ids
		tile_1 = tilesMap[id_1]
		tile_2 = tilesMap[id_2]
		sides = ['n','s','e','w']
		for (edge_1 in sides) {
			for (edge_2 in sides) {
				border_1 = get_border(tile_1, edge_1)
				border_2 = get_border(tile_2, edge_2)
				if (border_1 == border_2 || border_1 == border_2.reverse() ) {
					matchSide[id_1] = matchSide.containsKey(id_1) ? matchSide[id_1] +  edge_1:  edge_1
					matchSide[id_2] = matchSide.containsKey(id_2) ? matchSide[id_2] +  edge_2:  edge_2
				}
			}
		}
	}
	//println matchSide
	matchSide.each { k,v -> 
		if (v.size() == 2) {
			cornersMap[k]=v
		}
	}
	assert cornersMap.size() == 4
	return cornersMap
}

puzzles =  get_input()
corners =  match_puzzles(puzzles)
Long stage_1 = 1
corners.keySet().collect {stage_1*=it}
println "Stage_1: -> ${stage_1}"
