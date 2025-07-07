import Vapor

func routes(_ app: Application) throws {
	app.get("test") { req async in
		return "It works!"
	}
}
