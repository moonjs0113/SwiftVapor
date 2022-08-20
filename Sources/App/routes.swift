import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    for index in 1..<19 {
        app.get("flatfish_sashimi_\(index).mp4") { req -> Response in
            let directoryURL = DirectoryConfiguration.detect().publicDirectory + "flatfish_sashimi#\(index).MP4"
            return req.fileio.streamFile(at: directoryURL, mediaType: .multipart)
        }
    }
    
    let composers = ["schubert", "tchaikovsky", "bach", "chopin", "beethoven", "mozart"]
    
    for composer in composers {
        app.get("\(composer).mp3") { req -> Response in
            let directoryURL = DirectoryConfiguration.detect().publicDirectory + "\(composer).mp3"
            return req.fileio.streamFile(at: directoryURL, mediaType: .multipart)
        }
    }
    
    app.get("testVideo.mp4") { req -> Response in
        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "testVideo.mp4"
        return req.fileio.streamFile(at: directoryURL, mediaType: .multipart)
    }
    
    try app.register(collection: QuizController())
//    try app.register(collection: TodoController())
//    try app.register(collection: TaskController())
//    try app.register(collection: CourseController())
//    try app.register(collection: StepController())
}
