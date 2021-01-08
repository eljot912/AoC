def getInput() {
	File file = new File('example')
    input=file.text.replace('\r','').split('\n\n')
    outputMap=[:]
    for (tile in input) {
        List t = tile.split('\n')
        int tileID = Integer.parseInt(t[0][-5..-2])
        outputMap[tileID] = t[1..-1]
    }
    return outputMap
}

def getBorder(tileArray,edge) {
	String border = ''
	switch(edge) {
		case 'n': border = tileArray[0]; break
		case 's': border = tileArray[-1]; break
		case 'e': border = (tileArray.collect { it[-1] }).join(); break
		case 'w': border = (tileArray.collect { it[0] }).join(); break
	}
	return border
}

def matchPuzzles(tilesMap) {
    matchSide = [:]
    cornersMap = [:]
    tileCombos = [tilesMap.keySet(),tilesMap.keySet()].combinations().findAll{a,b-> a <b}
	for (ids in tileCombos) {
		(id_1, id_2) = ids
		tile_1 = tilesMap[id_1]
		tile_2 = tilesMap[id_2]
		sides = ['n','s','e','w']
		for (edge_1 in sides) {
			for (edge_2 in sides) {
				border_1 = getBorder(tile_1, edge_1)
				border_2 = getBorder(tile_2, edge_2)
				if (border_1 == border_2 || border_1 == border_2.reverse() ) {
					matchSide[id_1] = matchSide.containsKey(id_1) ? matchSide[id_1] +  edge_1:  edge_1
					matchSide[id_2] = matchSide.containsKey(id_2) ? matchSide[id_2] +  edge_2:  edge_2
				}
			}
		}
	}
	matchSide.each { k,v -> 
		if (v.size() == 2) {
			cornersMap[k]=v
		}
	}
	return cornersMap
}

def rotateObject(tileObject) {
    rotated  = []
    for (column in 0..tileObject[0].size()-1) {
        rotated_row = ''
        for (row in tileObject[-1..-(tileObject.size())]) {
            rotated_row+=row[column]
        }
        rotated.add(rotated_row)
    }
    return rotated
}

def tileArranges(inputTile) {
	arranges = []
	arranges.add(inputTile)
	flipTile = inputTile.reverse()
	for (r in 1..3) {
		inputTile = rotateObject(inputTile)
		arranges.add(inputTile)
	}
	arranges.add(flipTile)
	for (r in 1..3) {
		flipTile = rotateObject(flipTile)
		arranges.add(flipTile)
	}
	return arranges
}

def removeBorder(inputTile) {
	strippedTile=(inputTile[1..inputTile.size()-2]).collect { it[1..it.size()-2] }
	//strippedTile=strippedTile.collect { it[1..it.size()-2] }
	return strippedTile
}

puzzles =  getInput()
corners =  matchPuzzles(puzzles)
Long stage_1 = 1
corners.keySet().collect {stage_1*=it}
println "Stage_1: -> ${stage_1}"

imageSize=Math.sqrt(puzzles.size()) as Integer
cornerPuzzleID = corners.keySet()[0]
cornerPuzzleEdges = corners[cornerPuzzleID]
cornerPuzzle = puzzles[cornerPuzzleID]
puzzles.remove(cornerPuzzleID)

if (cornerPuzzleEdges in ['ne', 'en']) {
	cornerPuzzle = rotateObject(cornerPuzzle)
}
else if (cornerPuzzleEdges in ['nw', 'wn']) {
	cornerPuzzle = rotateObject(rotateObject(cornerPuzzle))
}
else if (cornerPuzzleEdges in ['sw','ws']) {
	cornerPuzzle = rotateObject(rotateObject(rotateObject(cornerPuzzle)))
}
