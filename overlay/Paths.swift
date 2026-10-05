import Foundation

/// Filesystem locations shared by the overlay and the zsh plugin.
enum Paths {
    static let root = FileManager.default.homeDirectoryForCurrentUser.path + "/.terminal-animals"
    static let runDir = root + "/run"
    static let events = runDir + "/events"
    static let pid = runDir + "/pid"
    /// `key=value` lines (coat, groom, accessory). Written by the plugin, read by the overlay.
    static let config = root + "/config"
}
