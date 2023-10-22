import Foundation

public struct Bitrate: Codable {
  public var name: String
  public var id: String?
  public var format: String?
  public var url: String?

  public init(name: String, id: String? = nil, format: String? = nil, url: String? = nil) {
    self.name = name
    self.id = id
    self.format = format
    self.url = url
  }

  public static func getBitrates(urls: [String]) -> [Bitrate] {
    var list: [Bitrate] = []

    let qualityLevels = QualityLevel.availableLevels(urls.count)

    for (index, url) in urls.enumerated() {
      list.append(Bitrate(name: qualityLevels[index].rawValue, url: url))
    }

    return list
  }
}