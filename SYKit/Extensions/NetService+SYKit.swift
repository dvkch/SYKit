//
//  NetService+SYKit.swift
//  SYKit
//
//  Created by syan on 24/02/2023.
//  Copyright © 2023 Syan. All rights reserved.
//

import Foundation

public class NetAddress {
    public enum Family {
        case ip4
        case ip6
    }
    
    public let family: Family
    public let ip: String
    public let port: Int
    public let host: String
    public let serv: String
    
    public init(family: Family, ip: String, port: Int, host: String, serv: String) {
        self.family = family
        self.ip = ip
        self.port = port
        self.host = host
        self.serv = serv
    }
}

public extension NetService {
    var parsedAddresses: [NetAddress]? {
        return addresses?.compactMap { $0.netAddress }
    }
}

public extension Data {
    var netAddress: NetAddress? {
        var ipBuffer   = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        var portBuffer = [CChar](repeating: 0, count: Int(NI_MAXSERV))
        var hostBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        var servBuffer = [CChar](repeating: 0, count: Int(NI_MAXSERV))
        var family: NetAddress.Family = .ip4

        let err = withUnsafeBytes { buf -> Int32 in
            let sa = buf.baseAddress!.assumingMemoryBound(to: sockaddr.self)

            if sa.pointee.sa_family == AF_INET {
                family = .ip4
            }

            if sa.pointee.sa_family == AF_INET6 {
                family = .ip6
            }

            let err1 = getnameinfo(
                sa, socklen_t(sa.pointee.sa_len),
                &ipBuffer, socklen_t(ipBuffer.count),
                &portBuffer, socklen_t(portBuffer.count),
                NI_NUMERICHOST | NI_NUMERICSERV
            )

            let err2 = getnameinfo(
                sa, socklen_t(sa.pointee.sa_len),
                &hostBuffer, socklen_t(hostBuffer.count),
                &servBuffer, socklen_t(servBuffer.count),
                0
            )
            
            return err1 > 0 ? err1 : err2
        }
        guard err == 0 else { return nil }

        let ip   = String(cString: hostBuffer)
        let port = String(cString: portBuffer)
        let host = String(cString: hostBuffer)
        let serv = String(cString: servBuffer)
        return .init(family: family, ip: ip, port: Int(port) ?? 0, host: host, serv: serv)
    }
}
