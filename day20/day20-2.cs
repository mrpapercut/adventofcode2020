using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace AOCDay20 {
    class Tile {
        public int TILE_WIDTH = 10;

        private const int FLIP_HORIZONTAL = 0;
        private const int FLIP_VERTICAL = 1;

        public string[] dirs = new string[]{"Top","Right","Bottom","Left"};

        private int tileNumber;
        public string[,] originalLines;
        public string[,] currentLines;

        public enum tileState {
            initial = 0,
            rot90 = 1,
            rot180 = 2,
            rot270 = 3,
            flipHor = 4,
            flipVer = 5,
            flipHorRot90 = 6,
            flipVerRot90 = 7,
            flipHorRot270 = 8,
            flipVerRot270 = 9,
        };
        private tileState currentState = tileState.initial;

        public Tile(int tileNum, string[,] lines) {
            tileNumber = tileNum;
            originalLines = currentLines = lines;
        }

        private int bitArrayToInt(BitArray bitArray) {
            int[] array = new int[1];
            bitArray.CopyTo(array, 0);
            return array[0];
        }

        public void logLayout(string [,] layout = null) {
            if (layout == null) {
                layout = currentLines;
            }

            Console.WriteLine("---");
            for (int i = 0; i < layout.GetLength(0); i++) {
                for (int j = 0; j < layout.GetLength(1); j++) {
                    Console.Write(layout[i, j]);
                }
                Console.Write("\n");
            }
        }

        public void logEdgeCount() {
            int[] edges = countEdges();

            Console.WriteLine("---");
            for (int i = 0; i < edges.Length; i++) {
                Console.Write("{0}: {1} ", dirs[i], edges[i]);
            }
            Console.Write("\n");
        }

        public Tile clone() {
            Tile clonedTile = new Tile(tileNumber, originalLines);
            clonedTile.setTileState(getTileState());

            return clonedTile;
        }

        public int getTileNumber() {
            return tileNumber;
        }

        public int getTileState() {
            return (int) (tileState)currentState;
        }

        public void setTileState(int state) {
            switch (state) {
                case 0: reset(); break;
                case 1: rotate90(); break;
                case 2: rotate180(); break;
                case 3: rotate270(); break;
                case 4: flipHor(); break;
                case 5: flipVer(); break;
                case 6:
                case 9:
                    flipRot(FLIP_HORIZONTAL, 90); break;
                case 7:
                case 8:
                    flipRot(FLIP_VERTICAL, 90); break;
            }

            currentState = (tileState)state;
        }

        public void reset() {
            currentLines = originalLines;
            currentState = tileState.initial;
        }

        private string[,] rotate(int degrees = 90) {
            if (degrees % 90 != 0) {
                throw new Exception("Invalid parameter for degrees");
            }

            int n = TILE_WIDTH;
            string [,] ret = new string[n, n];

            // Reset current lines
            currentLines = originalLines;

            int rot = (degrees / 90) % 4;
            if ((degrees / 90) % 4 == 1) {
                for (int i = 0; i < n; i++) {
                    for (int j = 0; j < n; j++) {
                        ret[j, i] = currentLines[n - i - 1, j];
                    }
                }
            } else if ((degrees / 90) % 4 == 3) {
                for (int i = 0; i < n; i++) {
                    for (int j = 0; j < n; j++) {
                        ret[j, i] = currentLines[i, n - j - 1];
                    }
                }
            }

            return ret;
        }

        private string[,] flip(int type, string[,] lines = null) {
            if (lines == null) {
                lines = originalLines;
            }

            int rows = lines.GetLength(0);
            int cols = lines.GetLength(1);

            string [,] ret = new string[rows, cols];

            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < cols; j++) {
                    if (type == FLIP_HORIZONTAL) {
                        ret[i, j] = lines[i, cols - j - 1];
                    } else if (type == FLIP_VERTICAL) {
                        ret[i, j] = lines[rows - i - 1, j];
                    }
                }
            }

            return ret;
        }

        public void rotate90() {
            currentLines = rotate(90);
            currentState = tileState.rot90;
        }

        public void rotate180() {
            string [,] tmp = null;

            tmp = flip(FLIP_HORIZONTAL);
            tmp = flip(FLIP_VERTICAL, tmp);

            currentLines = tmp;
            currentState = tileState.rot180;
        }

        public void rotate270() {
            currentLines = rotate(270);
            currentState = tileState.rot270;
        }

        public void flipHor() {
            currentLines = flip(FLIP_HORIZONTAL);
            currentState = tileState.flipHor;
        }

        public void flipVer() {
            currentLines = flip(FLIP_VERTICAL);
            currentState = tileState.flipVer;
        }

        public void flipRot(int flipType, int rotateAmount) {
            string [,] tmp = null;
            tmp = rotate(rotateAmount);
            tmp = flip(flipType, tmp);

            currentLines = tmp;

            if (flipType == FLIP_HORIZONTAL) {
                if (rotateAmount == 90) currentState = tileState.flipHorRot90;
                if (rotateAmount == 270) currentState = tileState.flipHorRot270;
            } else {
                if (rotateAmount == 90) currentState = tileState.flipVerRot90;
                if (rotateAmount == 270) currentState = tileState.flipVerRot270;
            }
        }

        public int[] countEdges() {
            int[] edges = new int[4];
            BitArray ba = new BitArray(10);

            int i;

            // Top
            for (i = 0; i < currentLines.GetLength(1); i++) ba[i] = currentLines[0, i] == "#";
            edges[0] = bitArrayToInt(ba);

            // Right
            ba = new BitArray(10);
            for (i = 0; i < currentLines.GetLength(0); i++) ba[i] = currentLines[i, currentLines.GetLength(1) - 1] == "#";
            edges[1] = bitArrayToInt(ba);

            // Bottom
            ba = new BitArray(10);
            for (i = 0; i < currentLines.GetLength(1); i++) ba[i] = currentLines[currentLines.GetLength(0) - 1, i] == "#";
            edges[2] = bitArrayToInt(ba);

            // Left
            ba = new BitArray(10);
            for (i = 0; i < currentLines.GetLength(0); i++) ba[i] = currentLines[i, 0] == "#";
            edges[3] = bitArrayToInt(ba);

            return edges;
        }

        public int[] findAllEdges() {
            int[] allEdges = new int[24];
            int[] edges = new int[4];

            int i;

            // Rotate 0 degrees (initial)
            edges = countEdges();
            for (i = 0; i < 4; i++) allEdges[i] = edges[i];

            // Rotate 90 degrees
            rotate90();
            edges = countEdges();
            for (i = 0; i < 4; i++) allEdges[i + 4] = edges[i];

            // Rotate 180 degrees
            rotate180();
            edges = countEdges();
            for (i = 0; i < 4; i++) allEdges[i + 8] = edges[i];

            // Rotate 270 degrees
            rotate270();
            edges = countEdges();
            for (i = 0; i < 4; i++) allEdges[i + 12] = edges[i];

            // Flip initial horizontal
            flipHor();
            edges = countEdges();
            for (i = 0; i < 4; i++) allEdges[i + 20] = edges[i];

            // Flip initial vertical
            flipVer();
            edges = countEdges();
            for (i = 0; i < 4; i++) allEdges[i + 16] = edges[i];

            // Reset for good measure
            reset();

            return allEdges;
        }

        public string getLine(int ln) {
            string line = "";

            for (int i = 1; i < TILE_WIDTH - 1; i++) {
                line += currentLines[ln, i];
            }

            return line;
        }
    }

    class FullImage : Tile {
        const int TILES_HORIZONTAL = 12;
        const int TILES_VERTICAL = 12;

        private int LINE_WIDTH = 8 * TILES_HORIZONTAL;

        public FullImage(string[,] lines) : base(0, lines) {
            TILE_WIDTH = 8 * TILES_HORIZONTAL;

            /*
            for (int i = 0; i < LINE_WIDTH; i++) {
                for (int j = 0; j < LINE_WIDTH; j++) {
                    Console.Write(currentLines[i, j]);

                }
                Console.Write("\n");
            }

            Console.WriteLine("--- Rotated 90:");
            rotate90();

            for (int i = 0; i < LINE_WIDTH; i++) {
                for (int j = 0; j < LINE_WIDTH; j++) {
                    Console.Write(currentLines[i, j]);

                }
                Console.Write("\n");
            }
            */
        }

        public int findMonsters() {
            int monster_counter = 0;

            int[,] monster = new int[15,2] {
                {0, 18},
                {1, 0}, {1, 5}, {1, 6}, {1, 11}, {1, 12}, {1, 17}, {1, 18}, {1, 19},
                {2, 1}, {2, 4}, {2, 7}, {2, 10}, {2, 13}, {2, 16}
            };

            int mc = 0;
            for (int i = 0; i < LINE_WIDTH - 2; i++) {
                // The monster has a fixed width of 20, each line is 24 chars long. So for each line,
                // we only have to check if the first char of second line of the monster occurs in first 4 characters
                // Then check if the line below that matches
                for (int j = 0; j < LINE_WIDTH; j++) {
                    if (j < 4) {
                        for (int m = 0; m < 15; m++) {
                            if (currentLines[i + monster[m, 0], j + monster[m, 1]] == "#") {
                                mc++;
                            }
                        }
                        if (mc == 15) {
                            Console.WriteLine("Warning: Monster at {0},{1} ({2} hits)", i, j, mc);
                            monster_counter++;
                        }
                        mc = 0;
                    }
                }
            }

            return monster_counter;
        }

        public int countWaterRoughness(int monster_counter) {
            int counter = 0;

            for (int i = 0; i < LINE_WIDTH; i++) {
                for (int j = 0; j < LINE_WIDTH; j++) {
                    if (currentLines[i, j] == "#") {
                        counter++;
                    }

                }
            }

            Console.WriteLine(counter - (monster_counter * 15));

            return counter;
        }
    }

    class JurassicJigsaw {
        private ArrayList filecontents = new ArrayList();
        private List<Tile> tileList = new List<Tile>();

        const int TILES_HORIZONTAL = 12;
        const int TILES_VERTICAL = 12;
        const int LINE_WIDTH = TILES_HORIZONTAL * 8;

        private void readFile(string filename) {
            ArrayList al = new ArrayList();

            try {
                using (StreamReader sr = new StreamReader(filename)) {
                    string line;

                    while ((line = sr.ReadLine()) != null) {
                        al.Add(line);
                    }
                }
            } catch (Exception e) {
                Console.WriteLine("File could not be read:");
                Console.WriteLine(e.Message);
            }

            filecontents = al;
        }

        private void parseFileContents() {
            int tileNum = 0;
            int lc = 0;
            string[,] lines = new string[10,10];
            string[] line = new string[10];

            foreach (string i in filecontents) {
                if (i.Trim().StartsWith("Tile")) { // If line starts with "Tile x:", next lines are the new tile, so store tile-number now
                    tileNum = Int32.Parse(i.Replace("Tile ", "").Replace(":", ""));
                } else if (i.Length == 0) { // If blank line, save previously collected lines
                    tileList.Add(new Tile(tileNum, lines));

                    lc = 0;
                    tileNum = 0;
                    lines = new string[10,10];
                } else { // Else add lines
                    for (int j = 0; j < i.Length; j++) {
                        lines[lc,j] = i[j].ToString();
                    }

                    lc++;
                }
            }

            // For some reason the last item isn't added
            tileList.Add(new Tile(tileNum, lines));
        }

        public int[] getCornerTiles() {
            int[] cornertiles = new int[4];
            int ct = 0;
            for (int i = 0; i < tileList.Count(); i++) {
                Tile tile = tileList[i];

                int count = 0;
                int[] edges = tile.findAllEdges();

                for (int j = 0; j < tileList.Count(); j++) {
                    if (tileList[j].getTileNumber() != tile.getTileNumber()) {
                        int[] subedges = tileList[j].findAllEdges();
                        count += (int) edges.Intersect(subedges).Count();
                    }
                }

                if (count == 4) {
                    cornertiles[ct] = tile.getTileNumber();
                    ct++;
                }
            }

            return cornertiles;
        }

        public Tile getTileByNumber(int tileNumber) {
            for (int i = 0; i < tileList.Count(); i++) {
                if (tileList[i].getTileNumber() == tileNumber) {
                    return tileList[i];
                }
            }

            return null;
        }

        public Tile matchRight(Tile tileToMatch) {
            int[] edges = tileToMatch.countEdges();

            Tile matched = null;

            for (int i = 0; i < tileList.Count; i++) {
                Tile neighbour = tileList[i];

                if (neighbour.getTileNumber() == tileToMatch.getTileNumber()) {
                    continue;
                }

                for (int j = 0; j < 10; j++) {
                    neighbour.setTileState(j);
                    int[] neighbour_edges = neighbour.countEdges();

                    if (edges[1] == neighbour_edges[3]) {
                        return neighbour.clone();
                    }
                }
            }

            return matched;
        }

        public Tile matchDown(Tile tileToMatch) {
            int[] edges = tileToMatch.countEdges();

            Tile matched = null;

            for (int i = 0; i < tileList.Count; i++) {
                Tile neighbour = tileList[i];

                if (neighbour.getTileNumber() == tileToMatch.getTileNumber()) {
                    continue;
                }

                for (int j = 0; j < 10; j++) {
                    neighbour.setTileState(j);
                    int[] neighbour_edges = neighbour.countEdges();

                    if (edges[2] == neighbour_edges[0]) {
                        return neighbour.clone();
                    }
                }
            }

            return matched;
        }

        public Tile[][] buildImage(int skipState = -1) {
            int columns = (int) Math.Sqrt((double) tileList.Count);

            int[] cornertiles = getCornerTiles();

            Tile starting_tile = getTileByNumber(cornertiles[0]);
            Tile matchedRight = null;
            Tile matchedDown = null;

            for (int i = 0; i < 10; i++) { // 10 is number of possible states
                if (skipState >= 0 && skipState == i) {
                    continue;
                }

                starting_tile.setTileState(i);
                matchedRight = matchRight(starting_tile);
                matchedDown = matchDown(starting_tile);

                if (matchedRight != null && matchedDown != null) {
                    // Starting tile has rotated correctly
                    break;
                }
            }

            Tile[][] image = new Tile[columns][];
            Tile[] line = new Tile[columns];
            Tile tmp = null;
            int lineidx = 0;
            int imgidx = 0;

            // Add starting tile
            line[lineidx] = starting_tile.clone();
            lineidx++;
            for (int i = 0; i < columns * columns; i++) {
                if (lineidx == 0) {
                    tmp = matchDown(image[imgidx - 1][0]);
                } else {
                    tmp = matchRight(line[lineidx - 1]);
                }

                line[lineidx] = tmp;
                lineidx++;

                if (lineidx == columns) {
                    image[imgidx] = line;
                    imgidx++;
                    line = new Tile[columns];
                    lineidx = 0;
                }
            }

            return image;
        }

        public FullImage combineTiles(Tile[][] image) {
            string[,] fullImage = new string[LINE_WIDTH, LINE_WIDTH];
            string[] combinedTiles = new string[LINE_WIDTH];
            string line = "";

            int lc = 0;
            for (int i = 0; i < TILES_HORIZONTAL; i++) {
                for (int k = 1; k < 9; k++) {
                    for (int j = 0; j < TILES_VERTICAL; j++) {
                        line += image[i][j].getLine(k);
                    }
                    combinedTiles[lc] = line;
                    line = "";
                    lc++;
                }
            }

            for (int i = 0; i < combinedTiles.Length; i++) {
                for (int j = 0; j < combinedTiles[0].Length; j++) {
                    fullImage[i,j] = combinedTiles[i][j].ToString();
                }
            }

            FullImage fullImageInstance = new FullImage(fullImage);

            return fullImageInstance;
        }

        static void Main(string[] args) {
            JurassicJigsaw self = new JurassicJigsaw();

            self.readFile("./day20/day20.txt");
            self.parseFileContents();

            Tile[][] image = self.buildImage();
            FullImage fullImage = self.combineTiles(image);

            for (int i = 0; i < 10; i++) {
                fullImage.setTileState(i);
                int numberOfMonsters = fullImage.findMonsters();
                Console.WriteLine("{0} monsters found at state {1}", numberOfMonsters, i);
                if (numberOfMonsters > 0) {
                    int waterRoughness = fullImage.countWaterRoughness(numberOfMonsters);
                }
            }
        }
    }
}
