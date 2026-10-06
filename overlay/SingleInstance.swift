import Foundation

/// Keeps exactly one overlay alive. The first process takes an exclusive lock on a file and holds it
/// for its whole life; the kernel releases it if the process exits or crashes, so there is no stale
/// state to clean up. Unlike checking a pid file, the lock is atomic: shells that start the overlay
/// at the same instant (several terminals opening at once) cannot all win.
enum SingleInstance {
    private static var lockDescriptor: Int32 = -1

    /// Returns normally for the one process that gets the lock; every other process exits.
    static func claimOrExit() {
        try? FileManager.default.createDirectory(atPath: Paths.runDir, withIntermediateDirectories: true)
        let fd = open(Paths.lock, O_CREAT | O_RDWR, 0o644)
        guard fd >= 0, flock(fd, LOCK_EX | LOCK_NB) == 0 else { exit(0) }
        lockDescriptor = fd   // never closed: closing would release the lock
    }
}
