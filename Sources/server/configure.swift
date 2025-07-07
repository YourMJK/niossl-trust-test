import Vapor
import NIOSSL

// configures your application
public func configure(_ app: Application) async throws {
	// Setup TLS configuration with custom certificate
	guard let certPath = Environment.get("CERT") else {
		throw ConfigurationError.missingCertificateFile
	}
	guard let keyPath = Environment.get("KEY") else {
		throw ConfigurationError.missingPrivateKeyFile
	}
	app.logger.notice("Using certficate: \(certPath)")
	app.logger.notice("Using private key: \(keyPath)")
	
	let certificateChain = try NIOSSLCertificate.fromPEMFile(certPath)
	let privateKey = try NIOSSLPrivateKey(file: keyPath, format: .pem)
	
	app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
		certificateChain: certificateChain.map { .certificate($0) },
		privateKey: .privateKey(privateKey)
	)
	
	// Uncomment to serve files from /Public folder
	//app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
	
	// Register routes
	try routes(app)
}

enum ConfigurationError: Error {
	case missingCertificateFile
	case missingPrivateKeyFile
}
