import XCTest
@testable import Percent

final class PercentTests: XCTestCase {
    func testThatAPercentCanBeCreated() {
        let fiftyPercent = Percent(50)
        let fiftyPercent02 = Percent(decimal: 0.5)
        let fiftyPercent03 = Percent("50%")
        let fiftyPercent04 = Percent("50")
        XCTAssertEqual(fiftyPercent, fiftyPercent02)
        XCTAssertEqual(fiftyPercent, fiftyPercent03)
        XCTAssertEqual(fiftyPercent, fiftyPercent04)
        XCTAssertEqual(fiftyPercent.description, "50%")
        XCTAssertEqual(fiftyPercent.percent, 50)
        XCTAssertEqual(fiftyPercent.decimal, 0.5)
    }
    
    func testThatArithmeticWorks() {
        XCTAssertEqual(Percent(50) + Percent(2), Percent(52))
        XCTAssertEqual(Percent(50) - Percent(7), Percent(43))
        XCTAssertEqual(Percent(50) * Percent(50), Percent(25))
        XCTAssertEqual(10 * Percent(50), 5)
        XCTAssertEqual(Percent(50) / Percent(25), 2)
        XCTAssertEqual(10 * Percent(50), 5)
        XCTAssertEqual(Percent(50).of(number: 10), 5)
        XCTAssertTrue(Percent(50) >= 0.5)
        XCTAssertEqual(Percent(20), Percent(20))
        XCTAssertEqual(Percent(50, maximum: 20), Percent(20))
        XCTAssertEqual(Percent(10, minimum: 20), Percent(20))
        XCTAssertGreaterThanOrEqual(Percent(20), Percent(20))
        XCTAssertGreaterThan(Percent(52), Percent(50))
        XCTAssertLessThan(Percent(52), Percent(70))
    }
    
    func testThatAUIPercentCanBeCreated() {
        let fiftyPercent = UIPercent(50, of: .screen(.width))
        let fiftyPercent02 = UIPercent(decimal: 0.5, of: .screen(.width))
        let fiftyPercent03 = UIPercent("50%", of: .screen(.width))
        let fiftyPercent04 = UIPercent("50", of: .screen(.width))
        XCTAssertEqual(fiftyPercent, fiftyPercent02)
        XCTAssertEqual(fiftyPercent, fiftyPercent03)
        XCTAssertEqual(fiftyPercent, fiftyPercent04)
        XCTAssertNotEqual(UIPercent(50, of: .screen(.width)), UIPercent(50, of: .screen(.radius)))
        XCTAssertEqual(fiftyPercent.description, "50% of screen width")
        XCTAssertEqual(UIPercent(23, of: .container(.diameter, of: "clock")).description, "23% of clock diameter")
        XCTAssertEqual(fiftyPercent.percent, 50)
        XCTAssertEqual(fiftyPercent.decimal, 0.5)
    }
    
    func testThatUIArithmeticWorks() {
        XCTAssertEqual(UIPercent(50, of: .screen(.width)) + UIPercent(2, of: .screen(.width)), UIPercent(52, of: .screen(.width)))
        XCTAssertEqual(UIPercent(50, of: .screen(.width)) - UIPercent(7, of: .screen(.width)), UIPercent(43, of: .screen(.width)))
        XCTAssertEqual(UIPercent(50, of: .screen(.width)) * UIPercent(50, of: .screen(.width)), UIPercent(25, of: .screen(.width)))
        XCTAssertEqual(10 * UIPercent(50, of: .screen(.width)), 5)
        XCTAssertEqual(UIPercent(50, of: .screen(.width)) / UIPercent(25, of: .screen(.width)), 2)
        XCTAssertEqual(10 * UIPercent(50, of: .screen(.width)), 5)
        XCTAssertEqual(UIPercent(50, of: .screen(.width)).of(number: 10), 5)
        XCTAssertTrue(UIPercent(50, of: .screen(.width)) >= 0.5)
    }
    
    func testThatUIPercentCanBeResolvedWithinContainer() {
        XCTAssertEqual(UIPercent(50, of: .container(.height)).resolve(within: CGSize(width: 100, height: 120)), 60)
        XCTAssertEqual(UIPercent(50, of: .container(.width)).resolve(within: CGSize(width: 100, height: 120)), 50)
        XCTAssertEqual(UIPercent(10, of: .container(.height)).resolve(within: CGSize(width: 100, height: 120)), 12)
        XCTAssertEqual(UIPercent(10, of: .container(.width)).resolve(within: CGSize(width: 100, height: 120)), 10)
    }

    static var allTests = [
        ("testThatAPercentCanBeCreated", testThatAPercentCanBeCreated),
        ("testThatArithmeticWorks", testThatArithmeticWorks),
        ("testThatAUIPercentCanBeCreated", testThatAUIPercentCanBeCreated),
        ("testThatUIArithmeticWorks", testThatUIArithmeticWorks),
        ("testThatUIPercentCanBeResolvedWithinContainer", testThatUIPercentCanBeResolvedWithinContainer),
    ]
}
