import ArgumentParser
import MQTTNIO
import NIOSSL
import NIOPosix
import Logging

@main
struct MQTTClient: AsyncParsableCommand {
	
	@Option(help: "Path to the PEM certificate file to trust")
	var cert: String
	
	@Option(help: "Hostname")
	var host: String
	
	@Option(help: "Port")
	var port: Int = 8883
	
	@Option(help: "Username")
	var user: String?
	
	@Option(help: "Password")
	var pass: String?
	
	@Option(help: "SNI server name")
	var sni: String?
	
	@Flag(help: "Use additionalTrustRoots instead of trustRoot")
	var additional: Bool = false
	
	
	mutating func run() async throws {
		var logger = Logger(label: "MQTT")
		logger.logLevel = .debug
		
		// TLS configuration
		var tlsConfig = TLSConfiguration.makeClientConfiguration()
		if additional {
			// ERROR: handshakeFailed
			logger.notice("Using additionalTrustRoots")
			tlsConfig.additionalTrustRoots = [.file(cert)]
		} else {
			// WORKS
			logger.notice("Using trustRoots")
			tlsConfig.trustRoots = .file(cert)
		}
		logger.notice("Trusting certificate \(cert)")
		
		// MQTT client configuration
		let config = MQTTNIO.MQTTClient.Configuration(
			userName: user,
			password: pass,
			useSSL: true,
			tlsConfiguration: .niossl(tlsConfig),
			sniServerName: sni
		)
		let identifier = Self._commandName
		
		let mqttClient = MQTTNIO.MQTTClient(
			host: host,
			port: port,
			identifier: identifier,
			eventLoopGroupProvider: .shared(MultiThreadedEventLoopGroup(numberOfThreads: 1)),
			logger: logger,
			configuration: config
		)
		defer {
			try? mqttClient.syncShutdownGracefully()
		}
		
		// Connect
		try await mqttClient.connect()
		logger.info("CONNECTED!")
		try await mqttClient.disconnect()
	}
	
}
