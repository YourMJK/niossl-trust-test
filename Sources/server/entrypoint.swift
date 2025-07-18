import Vapor

@main
enum Entrypoint {
	static func main() async throws {
		var env = try Environment.detect()
		try LoggingSystem.bootstrap(from: &env) { level in
			let console = Terminal()
			return { (label: String) in
				return ConsoleFragmentLogger(fragment: timestampDefaultLoggerFragment(), label: label, console: console, level: level)
			}
		}
		
		let app = try await Application.make(env)
		
		do {
			try await configure(app)
			try await app.execute()
		} catch {
			app.logger.report(error: error)
			try? await app.asyncShutdown()
			throw error
		}
		try await app.asyncShutdown()
	}
}
