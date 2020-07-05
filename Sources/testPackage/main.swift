//Prepare the Bunnies' Escape

/* 
You have maps of parts of the space station, each starting at a prison exit 
and ending at the door to an escape pod. The map is represented as a matrix 
of 0s and 1s, where 0s are passable space and 1s are impassable walls. The 
door out of the prison is at the top left (0,0) and the door into an escape 
pod is at the bottom right (𝑤−1,ℎ−1). Write a function answer(map) that 
generates the length of the shortest path from the prison door to the escape 
pod, where you are allowed to remove one wall as part of your remodeling 
plans. The path length is the total number of nodes you pass through, 
counting both the entrance and exit nodes. The starting and ending positions 
are always passable (0). The map will always be solvable, though you may or 
may not need to remove a wall. The height and width of the map can be from 2 
to 20. Moves can only be made in cardinal directions; no diagonal moves are allowed.
*/

import Deque

class Maze {
    let maze: [[Int]]
    lazy var count = getCount()

    init(_ maze: [[Int]]) {
        self.maze = maze
    }

    subscript(index: Int) -> [Int] {
        return self.maze[index]
    }

    func getCount() -> Int {
        return self.maze[0].count
    }
}


let maze_1 = Maze([
    [0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0]])  // Answer 21

let maze_6 = Maze([
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])  // Answer 39


struct SimplePoint {
    let x: Int
    let y: Int
    let val: Int

    init(_ x: Int, _ y: Int, _ val: Int) {
        self.x = x
        self.y = y
        self.val = val
    }
}
extension SimplePoint: Equatable {
    public static func == (lhs: SimplePoint, rhs: SimplePoint) -> Bool {
    return lhs.x == rhs.x &&
    lhs.y == rhs.y
    }
}

func getNeighbors(_ x: Int, _ y: Int, _ maze: Maze) -> [SimplePoint] {

    var returnArray: [SimplePoint] = []
    // Get point to left if active point is not on left edge
    if x != 0 {
        returnArray.append(SimplePoint(x-1, y, maze[y][x-1]))
    }
    if y != 0 {
        returnArray.append(SimplePoint(x, y-1, maze[y-1][x]))
    }
    if x != maze[0].count - 1 {
        returnArray.append(SimplePoint(x+1, y, maze[y][x+1]))
    }
    if y != maze.count - 1 {
        returnArray.append(SimplePoint(x, y+1, maze[y+1][x]))
    }
    return returnArray
}


struct Point {
    let x: Int
    let y: Int
    let val: Int
    var saldo: Bool
    var history: [SimplePoint] = []
    var neighbors: [SimplePoint] = []
    var maze: Maze = Maze([[0]])
    var simple: SimplePoint

    init(_ x: Int, _ y: Int, _ val: Int, _ saldo: Bool = false, 
        history: [SimplePoint] = [], neighbors: [SimplePoint] = [], 
        maze: Maze = Maze([[0]])) {

        self.x = x
        self.y = y
        self.val = val
        self.saldo = saldo
        self.history = history
        self.maze = maze
        if neighbors.count == 0 && maze[0] != [0] {
            self.neighbors = getNeighbors(x, y, maze)
        }
        self.simple = SimplePoint(x, y, val)

    }
}



func constructPointMaze(_ maze: Maze) -> [[Point]] {
    var pointMaze: [[Point]] = []
    for y in 0..<maze.count {
        pointMaze.append([])
        for x in 0..<maze[y].count {
            pointMaze[y].append(Point(x, y, maze[y][x], maze: maze))
        }
    }
    return pointMaze
}

func getSteps(_ maze: [[Point]]) -> Int? {
    let goal = (maze[0].count-1, maze.count-1) // (maze width, maze height)
    var safety = 0
    let startPoint = maze[0][0]

    var queue: Deque<Point> = [startPoint]
    var activePoint: Point

    while queue.count > 0 {
        safety += 1
        
        activePoint = queue.popFirst()!
        for neighbor in activePoint.neighbors {
            if (neighbor.x, neighbor.y) == goal {
                return activePoint.history.count + 2
            } else if !(activePoint.history.contains(neighbor)) {
                if neighbor.val == 0 {
                    var temp = maze[neighbor.y][neighbor.x]
                    temp.history = activePoint.history + [activePoint.simple]
                    temp.saldo = activePoint.saldo
                    queue.append(temp)
                } else if neighbor.val == 1 && activePoint.saldo == false {
                    var temp = maze[neighbor.y][neighbor.x]
                    temp.history = activePoint.history + [activePoint.simple]
                    temp.saldo = true
                    queue.append(temp)
                }
            }
        }
    }
    return nil
}


if let steps = getSteps(constructPointMaze(maze_6)){
    print("The final number of steps is \(steps)")
} else {
    print("Impossible")
}
