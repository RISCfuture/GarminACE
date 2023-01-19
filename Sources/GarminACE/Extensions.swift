import Foundation

// https://forums.swift.org/t/extension-write-to-outputstream/42817/4
extension OutputStream {
    func write(data: Data) throws {
        var remaining = data[...]
        while !remaining.isEmpty {
            let bytesWritten = remaining.withUnsafeBytes { buf in
                // The force unwrap is safe because we know that `remaining` is
                // not empty. The `assumingMemoryBound(to:)` is there just to
                // make Swift’s type checker happy. This would be unnecessary if
                // `write(_:maxLength:)` were (as it should be IMO) declared
                // using `const void *` rather than `const uint8_t *`.
                self.write(
                    buf.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    maxLength: buf.count
                )
            }
            if bytesWritten == -1 { throw streamError! }
            else if bytesWritten == 0 { return }
            
            remaining = remaining.dropFirst(bytesWritten)
        }
    }
}

