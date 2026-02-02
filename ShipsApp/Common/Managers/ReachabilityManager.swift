//
//  ReachabilityManager.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 02.02.26.
//

import Network
import Foundation

final class ReachabilityManager {
    
    static let shared = ReachabilityManager()
    
    private init() {}
    
    func isInternetAvailable() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "NetworkMonitor")
            
            monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path.status == .satisfied)
                monitor.cancel()
            }
            
            monitor.start(queue: queue)
        }
    }
}
