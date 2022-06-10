import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("resourcesPath") { req -> String in
        let directoryString = DirectoryConfiguration.detect().resourcesDirectory
        return directoryString
    }
    
    app.get("publicPath") { req -> String in
        let directoryString = DirectoryConfiguration.detect().publicDirectory
        return directoryString
    }
    
    app.get("viewsPath") { req -> String in
        let directoryString = DirectoryConfiguration.detect().viewsDirectory
        return directoryString
    }
    
    app.get("workingPath") { req -> String in
        let directoryString = DirectoryConfiguration.detect().workingDirectory
        return directoryString
    }
    
//    app.get("testVideo.mov") { req -> EventLoopFuture<Response> in
//        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "testVideo.mov"
//        let fileUrl = URL(fileURLWithPath: directoryURL)
////        let data = Data(contentsOf: fileUrl)
//        return req.byteBufferAllocator.buffer(data: Data(contentsOf: fileUrl))
//
//
//    }
    
    for index in 1..<19 {
        app.get("flatfish_sashimi_\(index).mp4") { req -> Response in
            let directoryURL = DirectoryConfiguration.detect().publicDirectory + "flatfish_sashimi#\(index).MP4"
            return req.fileio.streamFile(at: directoryURL, mediaType: .multipart)
        }
    }
    
    app.get("testVideo.mp4") { req -> Response in
        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "testVideo.mp4"
        return req.fileio.streamFile(at: directoryURL, mediaType: .multipart)
//        let fileUrl = URL(fileURLWithPath: directoryURL)
//        do {
//            let data = try Data(contentsOf: fileUrl)
//            let body = Response.Body(data: data)
//
//            return Response(status: .ok, version: .http1_1, headers: .init(), body: body)
//        } catch {
//            return Response(status: .ok, version: .http1_1, headers: .init(), body: .empty)
//        }
        
    }
    
    app.get("testVideo") { req -> EventLoopFuture<Response> in
        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "testVideo.mov"
        return req.fileio.collectFile(at: directoryURL).map { biteBuffer in
            let body = Response.Body(buffer: biteBuffer)
            let response = Response(status: .ok, version: .http1_1, headers: .init(), body: body)
            return response
        }
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
