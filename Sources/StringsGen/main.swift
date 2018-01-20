import Foundation
import PathKit

let args = Array(CommandLine.arguments.dropFirst())

let root = args[0]

let baseLang = args[1]

let langProjs = Loader.loadLangProjs(at: Path(root))

let queue = OperationQueue()

queue.maxConcurrentOperationCount = 20

langProjs.forEach { langProj in
    queue.addOperation(BlockOperation {
        Worker.execute(for: langProj, baseLang: baseLang)
    })
}

queue.waitUntilAllOperationsAreFinished()
