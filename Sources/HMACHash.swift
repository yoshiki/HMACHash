#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import COpenSSL
import struct C7.Data
import typealias C7.Byte

public enum HashType {
    case SHA1, SHA224, SHA256, SHA384, SHA512
}

internal extension HashType {
    var evp: UnsafePointer<EVP_MD> {
        switch self {
        case .SHA1:
            return EVP_sha1()
        case .SHA224:
            return EVP_sha224()
        case .SHA256:
            return EVP_sha256()
        case .SHA384:
            return EVP_sha384()
        case .SHA512:
            return EVP_sha512()
        }
    }
}

public struct HMACHash {
    private static func _initialize() {
        SSL_library_init()
        SSL_load_error_strings()
        ERR_load_crypto_strings()
        OPENSSL_config(nil)
    }

    public init() {
        _ = HMACHash._initialize()
    }

    public func hmac(type: HashType, key: String, data: String) -> Data {
        let keyData = Data(key)
        let dataData = Data(data)
        var resultLen: UInt32 = 0
        let result = UnsafeMutablePointer<UInt8>(allocatingCapacity: Int(EVP_MAX_MD_SIZE))
        keyData.withUnsafeBufferPointer { keyPtr in
            dataData.withUnsafeBufferPointer { dataPtr in
                HMAC(type.evp,
                     keyPtr.baseAddress, Int32(keyData.count),
                     dataPtr.baseAddress, dataPtr.count,
                     result, &resultLen)
            }
        }

        let resultData = Data(Array(UnsafeBufferPointer<Byte>(start: result, count: Int(resultLen))))
        result.deinitialize(count: Int(resultLen))
        result.deallocateCapacity(Int(EVP_MAX_MD_SIZE))
        return resultData
    }
}
