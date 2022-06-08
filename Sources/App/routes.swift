import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
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
}
