//
//  NWPathMonitor+.swift
//  BJGG
//
//  Created by 황정현 on 2023/07/06.
//  https://stackoverflow.com/questions/74221389/use-nwpathmonitor-with-swift-modern-concurrency-asyncstream-vs-gcd-dispatchqu

import Network

extension NWPathMonitor {
    func paths() -> AsyncStream<NWPath> {
        AsyncStream { continuation in
            pathUpdateHandler = { path in
                continuation.yield(path)
            }
            continuation.onTermination = { [weak self] _ in
                self?.cancel()
            }
            start(queue: DispatchQueue(label: "NSPathMonitor.paths"))
        }
    }
}
