import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("path") { req -> String in
        let directoryString = DirectoryConfiguration.detect().resourcesDirectory
        return directoryString
    }
    
    
//    for index in 1..<19 {
//        app.get("flatfish_sashimi#\(index).mp4") { req -> Data in
//
//            return
//        }
//    }
    

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
}
