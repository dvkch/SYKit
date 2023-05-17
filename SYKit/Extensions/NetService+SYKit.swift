//
//  NetService+SYKit.swift
//  SYKit
//
//  Created by syan on 24/02/2023.
//  Copyright © 2023 Syan. All rights reserved.
//

import Foundation

public extension NetService {
    class Address {
        public enum Kind {
            case ip4
            case ip6
        }
        
        public let kind: Kind
        public let ip: String
        public let port: Int
        
        public init(kind: Kind, ip: String, port: Int) {
            self.kind = kind
            self.ip = ip
            self.port = port
        }
    }

    var parsedAddresses: [Address]? {
        return addresses?.compactMap { $0.ipAddress }
    }
}

private extension Data {
    var ipAddress: NetService.Address? {
        var hostBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        var servBuffer = [CChar](repeating: 0, count: Int(NI_MAXSERV))
        var kind: NetService.Address.Kind = .ip4

        let err = withUnsafeBytes { buf -> Int32 in
            let sa = buf.baseAddress!.assumingMemoryBound(to: sockaddr.self)

            if sa.pointee.sa_family == AF_INET {
                kind = .ip4
            }

            if sa.pointee.sa_family == AF_INET6 {
                kind = .ip6
            }

            return getnameinfo(
                sa, socklen_t(sa.pointee.sa_len),
                &hostBuffer, socklen_t(hostBuffer.count),
                &servBuffer, socklen_t(servBuffer.count),
                NI_NUMERICHOST | NI_NUMERICSERV
            )
        }
        guard err == 0 else { return nil }

        let host = String(cString: hostBuffer)
        guard let port = Int(String(cString: servBuffer)) else { return nil }
        
        return .init(kind: kind, ip: host, port: port)
    }
}
