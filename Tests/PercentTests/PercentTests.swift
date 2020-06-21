import XCTest
@testable import Percent

final class PercentTests: XCTestCase {
    func testThatAPercentCanBeCreated() {
        let fiftyPercent = Percent(50)
        XCTAssertEqual(fiftyPercent.description, "50%")
        XCTAssertEqual(fiftyPercent.percent, 50)
        XCTAssertEqual(fiftyPercent.decimal, 0.5)
        XCTAssertEqual(fiftyPercent + Percent(2), Percent(52))
        XCTAssertEqual(fiftyPercent - Percent(7), Percent(43))
        XCTAssertEqual(fiftyPercent * fiftyPercent, Percent(25))
        XCTAssertEqual(10 * Percent(50), 5)
        XCTAssertEqual(fiftyPercent / Percent(25), Percent(200))
    }

    static var allTests = [
        ("testThatAPercentCanBeCreated", testThatAPercentCanBeCreated),
    ]
}
