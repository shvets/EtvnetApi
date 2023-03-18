import XCTest

import SimpleHttpClient
import DiskStorage

@testable import EtvnetApi

class EtvnetAPITests: XCTestCase {
  static let path = URL(fileURLWithPath: NSTemporaryDirectory())

  var subject: EtvnetApiService = {
    let configFile = ConfigFile<String>(path: path, fileName: "etvnet.config")

    var service = EtvnetApiService(configFile: configFile)

    do {
      try service.apiClient.loadConfig()
    }
    catch {
      print(error)
    }

    return service
  }()

  override func setUp() {
    super.setUp()

    do {
      try subject.authorize {
        do {
          Task {
            if let result = try await self.subject.apiClient.authorization() {
              print("Register activation code on web site \(self.subject.apiClient.authClient.getActivationUrl()): \(result.userCode)")

              if let response = await self.subject.apiClient.createToken(deviceCode: result.deviceCode) {
                XCTAssertNotNil(response.accessToken)
                XCTAssertNotNil(response.refreshToken)

                print("Result: \(result)")
              }
            }
          }
        } catch {
          XCTFail("Error: \(error)")
        }
      }
    } catch {
      XCTFail("Error: \(error)")
    }
  }

  func testGetChannels() async throws {
    let channels = try await subject.getChannels()

    print(try channels.prettify())

    XCTAssertNotNil(channels)
    XCTAssert(channels.count > 0)
  }

  func testGetArchive() async throws {
    if let result = try await subject.getArchive(channelId: 3) {
      print(try result.prettify())

      XCTAssertNotNil(result)
      XCTAssert(result.media.count > 0)
      XCTAssert(result.pagination.count > 0)
    }
    else {
      XCTFail()
    }
  }

  func testGetGenre() async throws {
    if let result = try await subject.getArchive(genre: 1) {
      print(try result.prettify())

      XCTAssertNotNil(result)
      XCTAssert(result.media.count > 0)
      XCTAssert(result.pagination.count > 0)
    }
    else {
      XCTFail()
    }
  }

  func testGetNewArrivals() async throws {
    let data = try await subject.getNewArrivals()!

    XCTAssertNotNil(data)
    XCTAssert(data.media.count > 0)
    XCTAssert(data.pagination.count > 0)
  }

//  func testGetBlockbusters() throws {
//    let exp = expectation(description: "Gets blockbusters")
//
//    _ = subject.getBlockbusters().subscribe(
//      onNext: { result in
//        print(result as Any)
//
//        XCTAssertNotNil(result)
//        XCTAssert(result!.media.count > 0)
//        XCTAssert(result!.pagination.count > 0)
//
//        exp.fulfill()
//      },
//      onError: { error in
//        print("Received error:", error)
//      })
//
//    waitForExpectations(timeout: 10, handler: nil)
//  }
//
//  func testGetCoolMovies() throws {
//    let exp = expectation(description: "Gets cool movies")
//
//    _ = subject.getCoolMovies(perPage: 15, page: 4).subscribe(
//      onNext: { result in
//        print(result as Any)
//
//        XCTAssertNotNil(result)
//        XCTAssert(result!.media.count > 0)
//        XCTAssert(result!.pagination.count > 0)
//
//        exp.fulfill()
//      },
//      onError: { error in
//        print("Received error:", error)
//      })
//
//    waitForExpectations(timeout: 10, handler: nil)
//  }

  func testGetGenres() async throws {
    let list = try await subject.getGenres()

    print(try list.prettify())

    XCTAssertNotNil(list)
    XCTAssert(list.count > 0)
  }

  func testSearch() async throws {
    let query = "news"
    let data = try await subject.search(query)!

    print(try data.prettify())

    XCTAssertNotNil(data)
    XCTAssert(data.media.count > 0)
    XCTAssert(data.pagination.count > 0)
  }

  func testPagination() async throws {
    let query = "news"

    let result1 = try await subject.search(query, perPage: 20, page: 1)!
    let pagination1 = result1.pagination

    XCTAssertEqual(pagination1.hasNext, true)
    XCTAssertEqual(pagination1.hasPrevious, false)
    XCTAssertEqual(pagination1.page, 1)

    let result2 = try await subject.search(query, perPage: 20, page: 2)!
    let pagination2 = result2.pagination

    XCTAssertEqual(pagination2.hasNext, true)
    XCTAssertEqual(pagination2.hasPrevious, true)
    XCTAssertEqual(pagination2.page, 2)
  }

  func testGetUrl() async throws {
    let id = 760894 // 329678
    let  bitrate = "1200"
    let format = "mp4"

    let urlData = try await subject.getUrl(id, format: format, mediaProtocol: "hls", bitrate: bitrate)

    print(try urlData.prettify())

    //    #print("Play list:\n" + self.service.get_play_list(url_data["url"]))
  }

  func testGetLiveChannelUrl() async throws {
    let id = 423
    let  bitrate = "800"
    let format = "mp4"

    let urlData = try await subject.getLiveChannelUrl(id, format: format, bitrate: bitrate)

    print(try urlData.prettify())

    //    #print("Play list:\n" + self.service.get_play_list(url_data["url"]))
  }

  func testGetMediaObjects() async throws {
    if let result = try await subject.getArchive(channelId: 3) {
      var mediaObject: EtvnetApiService.Media? = nil

      for item in result.media {
        let type = item.mediaType

        if type == .mediaObject {
          mediaObject = item
          break
        }
      }

      if let mediaObject = mediaObject {
        print(try mediaObject.prettify())
      }
    }
    else {
      XCTFail()
    }
  }

  func testGetContainer() async throws {
    if let result = try await subject.getArchive(channelId: 5) {
      var container: EtvnetApiService.Media? = nil

      for item in result.media {
        let type = item.mediaType

        if type == .container {
          container = item
          break
        }
      }

      print(try container!.prettify())
    }
    else {
      XCTFail()
    }
  }

  func testGetAllBookmarks() async throws {
    let data = try await subject.getBookmarks()!

    print(try data.prettify())

    XCTAssertNotNil(data)
    XCTAssert(data.bookmarks.count > 0)
    XCTAssert(data.pagination.count > 0)
  }

//  func testGetFolders() throws {
//    let result = subject.getFolders()
//
//    //print(result as Any)
//
//    XCTAssertEqual(result["status_code"], 200)
////        XCTAssert(result["data"].count > 0)
//  }

  func testGetBookmark() async throws {
    let bookmarks = try await subject.getBookmarks()!.bookmarks

    let bookmarkDetails = try await subject.getBookmark(id: bookmarks[0].id)

    print(try bookmarkDetails.prettify())

    XCTAssertNotNil(bookmarkDetails)
  }

  func _testAddBookmark() async throws {
    let id = 760894

    let _ = try await subject.addBookmark(id: id)

    //XCTAssertTrue(result)
  }

  func _testRemoveBookmark() async throws {
    let id = 760894

    let _ = try await subject.removeBookmark(id: id)

    //XCTAssertTrue(result)
  }

  func testGetTopicItems() async throws {
    for topic in EtvnetApiService.Topics {
      let data = try await subject.getTopicItems(topic)!

      print(try data.prettify())

      XCTAssertNotNil(data)
      XCTAssert(data.media.count > 0)
      XCTAssert(data.pagination.count > 0)
    }
  }

  func testGetVideoResolution() {
    //    puts subject.bfuncrate_to_resolution(1500)
  }

  func testGetAllLiveChannels() async throws {
    let list = try await subject.getLiveChannels()

    print(try list.prettify())

    XCTAssertNotNil(list)
    XCTAssert(list.count > 0)
  }

  func testGetLiveChannelsByCategory() async throws {
    let list = try await subject.getLiveChannelsByCategory(category: 7)

    print(try list.prettify())

    XCTAssertNotNil(list)
    XCTAssert(list.count > 0)
  }

  func testGetLiveFavoriteChannels() async throws {
    let list = try await subject.getLiveChannels(favoriteOnly: true)

    print(try list.prettify())

    XCTAssertNotNil(list)
    XCTAssert(list.count > 0)
  }

  func _testAddFavoriteChannel() async throws {
    let id = 46

    let result = try await subject.addFavoriteChannel(id: id)

    print(result)
  }

  func _testRemoveFavoriteChannel() async throws {
    let id = 46

    let result = try await subject.removeFavoriteChannel(id: id)

    print(result)
  }

  func testGetLiveSchedule() async throws {
    let list = try await subject.getLiveSchedule(liveChannelId: "59")

    print(try list.prettify())

    XCTAssertNotNil(list)
    XCTAssert(list.count > 0)
  }

  func testGetLiveCategories() async throws {
    let list = try await subject.getLiveCategories()

    print(try list.prettify())

    XCTAssertNotNil(list)
    XCTAssert(list.count > 0)
  }

  func testGetHistory() async throws {
    let data = try await subject.getHistory()!

    print(try data.prettify())

    XCTAssertNotNil(data)
    XCTAssert(data.media.count > 0)
    XCTAssert(data.pagination.count > 0)
  }

  func testGetChildren() async throws {
    let data = try await subject.getChildren(488406)!

    print(try data.prettify())

    XCTAssertNotNil(data)
    XCTAssert(data.children.count > 0)
    XCTAssert(data.pagination.count > 0)
  }

}
