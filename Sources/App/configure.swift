import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.postgres(hostname: "localhost",
                                port: 5432,
                                username: "ubuntu",
                                password: "password",
                                database: "vapordb"), as: .psql)
    
    //    app.databases.use(.postgres(
    //        hostname: Environment.get("localhost") ?? "localhost",
    //        port: Environment.get("5432").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
    //        username: Environment.get("ubuntu") ?? "ubuntu",
    //        password: Environment.get("passw0rd") ?? "passw0rd",
    //        database: Environment.get("vapordb") ?? "vapordb"
    //    ), as: .psql)
    
    app.migrations.add(CreateTodo())
    app.migrations.add(TaskMigration())
    app.migrations.add(CourseMigration())
    app.migrations.add(StepMigration())
    
    // register routes
    try routes(app)
}
