using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace AOCDay20 {
    class Tile {
        private const int TILE_WIDTH = 10;
        private const int TILE_HEIGHT = 10;

        private const int FLIP_HORIZONTAL = 0;
        private const int FLIP_VERTICAL = 1;

        public string[] dirs = new string[]{"Top","Right","Bottom","Left"};

        private int tileNumber;
        private string[,] originalLines;
        private string[,] currentLines;

        public enum tileState {
            initial = 0,
            rot90 = 1,
            rot180 = 2,
            rot270 = 3,
            fliphor = 4,
            flipver = 5
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

        public int getTileNumber() {
            return tileNumber;
        }

        public int getTileState() {
            return (int) (tileState)currentState;
        }

        public void setTileState(tileState state) {
            switch (state) {
                case tileState.initial: reset(); break;
                case tileState.rot90: rotate90(); break;
                case tileState.rot180: rotate180(); break;
                case tileState.rot270: rotate270(); break;
                case tileState.fliphor: flipHor(); break;
                case tileState.flipver: flipVer(); break;
            }

            currentState = state;
        }

        public void reset() {
            currentLines = originalLines;
            currentState = tileState.initial;
        }

        private string[,] rotate(int degrees = 90) {
            if (degrees % 90 != 0) {
                throw new Exception("Invalid parameter for degrees");
            }

            int n = 10;
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
            currentState = tileState.fliphor;
        }

        public void flipVer() {
            currentLines = flip(FLIP_VERTICAL);
            currentState = tileState.flipver;
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
    }

    class JurassicJigsaw {
        private ArrayList filecontents = new ArrayList();
        private List<Tile> tileList = new List<Tile>();

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
            string[][,] tile = new string[10][,];

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

        static void Main(string[] args) {
            JurassicJigsaw self = new JurassicJigsaw();

            self.readFile("./day20/day20.txt");
            self.parseFileContents();

            long prod = 1;
            for (int i = 0; i < self.tileList.Count; i++) {
                Tile tile = self.tileList[i];

                int[] edges = tile.findAllEdges();
                int count = 0;
                for (int j = 0; j < self.tileList.Count(); j++) {
                    if (self.tileList[j].getTileNumber() != tile.getTileNumber()) {
                        int[] subedges = self.tileList[j].findAllEdges();
                        count += (int) edges.Intersect(subedges).Count();
                    }
                }

                // Tiles either have 4, 6 or 8 matching edges (because of rotation/flipping).
                // 4 Matching edges must mean they are corner tiles
                if (count == 4) {
                    prod *= (long) tile.getTileNumber();
                }
            }

            Console.WriteLine("Product of corner tiles: {0}", prod);
        }
    }
}
