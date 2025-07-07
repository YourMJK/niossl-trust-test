import ArgumentParser
import AsyncHTTPClient
import NIOSSL
import NIOPosix
import Logging

@main
struct Client: AsyncParsableCommand {
	
	@Option(help: "Path to the PEM certificate file to trust")
	var cert: String
	
	@Option(help: "Hostname of request URL")
	var host: String = "localhost"
	
	@Option(help: "Port of request URL")
	var port: Int = 8080
	
	@Option(help: "Path of request URL")
	var path: String = "test"
	
	@Option(help: "SNI server name matching certificate")
	var sni: String?
	
	@Flag(help: "Use additionalTrustRoots instead of trustRoot")
	var additional: Bool = false
	
	
	mutating func run() async throws {
		var logger = Logger(label: "Client")
		logger.logLevel = .debug
		
		// TLS configuration
		var tlsConfig = TLSConfiguration.makeClientConfiguration()
		if additional {
			logger.notice("Using additionalTrustRoots")
			tlsConfig.additionalTrustRoots = [.file(cert)]
		} else {
			logger.notice("Using trustRoots")
			tlsConfig.trustRoots = .file(cert)
		}
		logger.notice("Trusting certificate \(cert)")
		
		// HTTP client configuration
		var config = HTTPClient.Configuration(tlsConfiguration: tlsConfig)
		if let sni {
			config.dnsOverride = [sni: host]
		}
		let client = HTTPClient(configuration: config)
		
		// Request
		do {
			let url = "https://\(sni ?? host):\(port)/\(path)"
			logger.info("Sending request: \(url)\(sni.map { " (resolving \($0) as \(host))" } ?? "")")
			
			let request = HTTPClientRequest(url: url)
			let response = try await client.execute(request, timeout: .seconds(3))
			logger.info("Response status: \(response.status)")
		}
		catch {
			try await client.shutdown()
			throw error
		}
	}
	
}
