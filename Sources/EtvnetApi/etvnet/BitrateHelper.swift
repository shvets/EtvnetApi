import common_defs

class BitrateHelper {
  static func getBitrates(files: [EtvnetApiService.FileType]) throws -> [Bitrate] {
    var bitrates: [Bitrate] = []

    let (mp4_data, _) = getFilesData(files: files)

    for item in mp4_data {
      let id = item.bitrate
      let format = item.format

      bitrates.append(Bitrate(name: id, id: id, format: format))
    }

    let qualityLevels = QualityLevel.availableLevels(bitrates.count)

    var newBitrates: [Bitrate] = []

    for (index, bitrate) in bitrates.enumerated() {
      var newBitrate = Bitrate(name: qualityLevels[index].rawValue, id: bitrate.id, format: bitrate.format)

      newBitrates.append(newBitrate)
    }

    return newBitrates
  }

  static func getFilesData(files: [EtvnetApiService.FileType]) -> (mp4: [QualityType], wmv: [QualityType]) {
    var mp4Files = [QualityType]()
    var wmvFiles = [QualityType]()

    for (index, item) in files.enumerated() {
      let bitrate = item.bitrate
      let format = item.format

      if format == "mp4" {
        mp4Files.append((id: String(index), bitrate: String(bitrate), format: format))
      }
      else if format == "wmv" {
        wmvFiles.append((id: String(index), bitrate: String(bitrate), format: format))
      }
    }

    func sortByBitrate(record1: QualityType, record2: QualityType) -> Bool {
      if let first = Int(record1.bitrate), let second = Int(record2.bitrate) {
        return first > second // highest first
      }

      return false
    }

    return (mp4: mp4Files.sorted(by: sortByBitrate), wmv: wmvFiles.sorted(by: sortByBitrate))
  }
}
