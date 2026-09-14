import Foundation

/// The reflected CRC-32 checksum (IEEE 802.3, polynomial 0xEDB88320) that terminates an `.ace` file.
enum CRC32 {
  private static let polynomial: UInt32 = 0xEDB8_8320
  private static let seed: UInt32 = 0xFFFF_FFFF

  private static let remainderTable: [UInt32] = (0...0xFF).map { byte in
    (0..<8).reduce(UInt32(byte)) { remainder, _ in
      remainder & 1 == 1 ? (remainder >> 1) ^ polynomial : remainder >> 1
    }
  }

  static func checksum(of bytes: some Sequence<UInt8>) -> UInt32 {
    bytes.reduce(seed) { remainder, byte in
      (remainder >> 8) ^ remainderTable[Int((remainder ^ UInt32(byte)) & 0xFF)]
    } ^ seed
  }
}
