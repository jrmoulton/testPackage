// Prepare the Bunnies' Escape

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
 to 20. Moves can only be made in cardinal directions; no diagonal moves are
 allowed.
 */
import Deque
import Dispatch

protocol Count {
    func ycount()
    // func xcount()
}

extension Count {
    func ycount() -> Int {
        return Self.count
    }

    // func xcount() -> Int {
    //     return Self[0].count
    // }
}

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
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

struct Point {
    let x: Int
    let y: Int
    let val: Int
    var saldo: Bool
    var history: [SimplePoint] = []
    var neighbors: [SimplePoint] = []
    var maze: [[Int]] = [[0]]
    var simple: SimplePoint

    init(_ x: Int, _ y: Int, _ val: Int, _ saldo: Bool = false,
         history: [SimplePoint] = [], neighbors: [SimplePoint] = [],
         maze: [[Int]] = [[0]]) {
        self.x = x
        self.y = y
        self.val = val
        self.saldo = saldo
        self.history = history
        self.maze = maze
        simple = SimplePoint(x, y, val)
        if neighbors.isEmpty, maze[0] != [0] {
            self.neighbors = getNeighbors(x, y, maze)
        }
    }

    func getNeighbors(_ x: Int, _ y: Int, _ maze: [[Int]]) -> [SimplePoint] {
        var returnArray: [SimplePoint] = []
        // Get point to left if active point is not on left edge
        if x != 0 {
            returnArray.append(SimplePoint(x - 1, y, maze[y][x - 1]))
        }
        if y != 0 {
            returnArray.append(SimplePoint(x, y - 1, maze[y - 1][x]))
        }
        if x != maze[0].count - 1 {
            returnArray.append(SimplePoint(x + 1, y, maze[y][x + 1]))
        }
        if y != maze.count - 1 {
            returnArray.append(SimplePoint(x, y + 1, maze[y + 1][x]))
        }
        return returnArray
    }
}

func constructPointMaze(_ maze: [[Int]]) -> [[Point]] {
    var pointMaze: [[Point]] = []
    for y in 0 ..< maze.count {
        pointMaze.append([])
        for x in 0 ..< maze[0].count {
            pointMaze[y].append(Point(x, y, maze[y][x], maze: maze))
        }
    }
    return pointMaze
}

func getSteps(_ maze: [[Point]]) -> Int? {
    let goal = (maze[0].count - 1, maze.count - 1) // (maze width, maze height)
    let startPoint = maze[0][0]
    var returnList: [[Int]] = []

    var queue: Deque<Point> = [startPoint]
    var activePoint: Point

    func printResult() {
        print("\n")
        for y in 0 ..< maze.count {
            returnList.append(maze[y].map { $0.val })
        }
        for tempPoint in activePoint.history {
            returnList[tempPoint.y][tempPoint.x] = 2
        }
        for list in returnList {
            print(list)
        }
        print("\n")
    }

    while !queue.isEmpty {
        activePoint = queue.popFirst()!
        for neighbor in activePoint.neighbors {
            if (neighbor.x, neighbor.y) == goal {
                activePoint.history += [activePoint.simple, neighbor]
                printResult()
                return activePoint.history.count
            } else if !activePoint.history.contains(neighbor) {
                if neighbor.val == 0 {
                    var temp = maze[neighbor.y][neighbor.x]
                    temp.history = activePoint.history + [activePoint.simple]
                    temp.saldo = activePoint.saldo
                    queue.append(temp)
                } else if neighbor.val == 1, activePoint.saldo == false {
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

let maze_2 = [
    [0, 1, 1, 0],
    [0, 0, 0, 1],
    [1, 1, 0, 0],
    [1, 1, 1, 0],
] // Answer 7

let maze_3 = [
    [0, 1, 0, 0, 0],
    [0, 0, 0, 1, 0],
    [1, 1, 1, 1, 0],
] // Answer 7

let maze_4 = [
    [0, 1, 1, 1],
    [0, 1, 0, 0],
    [1, 0, 1, 0],
    [1, 1, 0, 0],
] // Answer 7

let maze_5 = [
    [0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0],
] // Answer 11

let maze_6 = [
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
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
] // Answer 39

let maze_1 = [
    [0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0],
] // Answer 21

// I just need some space
func answer(_ maze: [[Int]]) -> String {
    let pointMaze = constructPointMaze(maze)
    if let steps = getSteps(pointMaze) {
        return "The final number of steps is \(steps)"
    } else {
        return "Impossible"
    }
}

let start = DispatchTime.now()
print(answer(maze_6))
let end = DispatchTime.now()
let nanoseconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds)
let milliseconds = nanoseconds / 1e6
print("Finished in \(milliseconds) miliseconds")
