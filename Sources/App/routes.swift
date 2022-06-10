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
    
    app.get("testVideo.mp4") { req -> Response in
        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "testVideo.mp4"
        return req.fileio.streamFile(at: directoryURL, mediaType: .multipart)
    }
    
    // /movies
    app.get("movies") { req in
        Movie.query(on: req.db).all()
    }
    
    // movies POST
    app.post("movies") { req -> EventLoopFuture<Movie> in
        let movie = try req.content.decode(Movie.self)
        return movie.create(on: req.db).map { movie }
    }
    
    try app.register(collection: TodoController())
    try app.register(collection: TaskController())
    try app.register(collection: CourseController())
}
