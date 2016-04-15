import PackageDescription

#if os(Linux)
let COpenSSLURL = "https://github.com/Zewo/COpenSSL.git"
#else
let COpenSSLURL = "https://github.com/Zewo/COpenSSL-OSX.git"
#endif

let package = Package(
    name: "HMACHash",
    dependencies: [
        .Package(url: COpenSSLURL, majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/Zewo/Data.git", majorVersion: 0, minor: 2),
    ]
)
