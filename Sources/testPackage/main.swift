// Prepare the Bunnies' Escape

// import Deque
import Dispatch

class Node<Element> {
    let value: Element
    var next: Node<Element>?
    var prev: Node<Element>?

    init(_ value: Element, _ next: Node? = nil, _ prev: Node? = nil) {
        self.value = value
        self.next = next
        self.prev = prev
    }
}

struct Queue<Element> {
    var head: Node<Element>?
    var tail: Node<Element>?
    var count: Int

    init(_ inp: Element) {
        let temp = Node(inp)
        head = temp
        tail = temp
        count = 1
    }

    var isEmpty: Bool { head == nil }

    mutating func append(_ item: Element) {
        let node = Node(item)
        count += 1
        if isEmpty {
            head = node
            tail = node
        } else {
            node.prev = tail
            tail!.next = node
            tail = node
        }
    }

    mutating func pop() -> Element? {
        if !isEmpty {
            count -= 1
            let temp = head
            if let next = head!.next {
                head = next
            } else {
                head = nil
            }
            return temp!.value
        }
        return nil
    }
}

extension Queue: CustomStringConvertible {
    var description: String { return "Queue contains: \(count) items." }
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
    let simple: SimplePoint

    init(_ x: Int, _ y: Int, _ val: Int, saldo: Bool = false,
         history _: [SimplePoint] = [], neighbors: [SimplePoint] = [],
         maze: [[Int]] = [[0]]) {
        simple = SimplePoint(x, y, val)
        self.x = x
        self.y = y
        self.val = val
        self.saldo = saldo
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

func getSteps(_ maze: [[Point]], _ optPrint: Bool = false) -> Int? {
    let goal = (maze[0].count - 1, maze.count - 1) // (maze width, maze height)
    let startPoint = maze[0][0]
    var returnList: [[Int]] = []

    var queue = Queue(startPoint)
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
        activePoint = queue.pop()!
        for neighbor in activePoint.neighbors {
            if (neighbor.x, neighbor.y) == goal {
                activePoint.history += [activePoint.simple, neighbor]
                if optPrint {
                    printResult()
                }
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

let maze_1 = [
    [0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0],
] // Answer 21

let maze_3 = [
    [0, 1, 0, 0, 0],
    [0, 0, 0, 1, 0],
    [1, 1, 1, 1, 0],
] // Answer 7

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
