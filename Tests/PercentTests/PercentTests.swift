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
        XCTAssertEqual(fiftyPercent / Percent(25), 2)
        XCTAssertEqual(10 * fiftyPercent, 5)
        XCTAssertEqual(fiftyPercent.of(number: 10), 5)
        XCTAssertTrue(fiftyPercent >= 0.5)
    }

    static var allTests = [
        ("testThatAPercentCanBeCreated", testThatAPercentCanBeCreated),
    ]
}
