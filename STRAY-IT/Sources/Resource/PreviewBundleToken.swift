import Foundation

internal final class PreviewBundleToken {
    deinit {}

    private static let previewBundlePath: URL = {
        let typeName = type(of: PreviewBundleToken())
        // "\(ModuleName).MyBundleToken"
        let nsClassString = NSStringFromClass(typeName)
        guard let bundleName = nsClassString.components(separatedBy: ".").first else {
            fatalError("failed get bundle name: \(nsClassString)")
        }

        let searchUrl: URL = Bundle(for: PreviewBundleToken.self)
            .bundleURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let list: [URL]
        do {
            list = try FileManager.default.contentsOfDirectory(at: searchUrl, includingPropertiesForKeys: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        let firstMatch: URL? = list.first { (url: URL) in
            let name = url.lastPathComponent
            return name.contains("_\(bundleName).bundle")
        }
        guard let res = firstMatch else {
            let jointed = list.map { $0.relativeString }
                .joined(separator: "\n")
            fatalError("no url contains: _\(bundleName).bundle\n\(jointed)")
        }
        return res
    }()
    public static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return Bundle(url: previewBundlePath)!
        } else {
            return Bundle.module
        }
        #else
        return Bundle(for: PreviewBundleToken.self)
        #endif
    }()
}
