//
//  RoundUpTimeWindow.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

enum RoundUpTimeWindow {

    case week

}

extension RoundUpTimeWindow {

    func dateRange(containing date: Date, in timeZone: TimeZone = .current) -> Range<Date> {
        switch self {
        case .week:
            weekDateRange(containing: date, in: timeZone)
        }
    }

    private func weekDateRange(containing date: Date, in timeZone: TimeZone) -> Range<Date> {
        guard
            let startOfWeek = date.startOfWeek(in: timeZone),
            let endOfWeek = startOfWeek.endOfWeek(in: timeZone)
        else {
            return date ..< date
        }

        return startOfWeek ..< endOfWeek
    }

}

extension RoundUpTimeWindow {

    func startDateOfPreviousTimeWindow(date: Date, in timeZone: TimeZone = .current) -> Date {
        let currentDateRange = dateRange(containing: date, in: timeZone)
        let oneDateTimeInterval: TimeInterval = 60 * 60 * 24
        let previousDay = currentDateRange.lowerBound.addingTimeInterval(-oneDateTimeInterval)
        let dateRange = dateRange(containing: previousDay, in: timeZone)
        return dateRange.lowerBound
    }

    func startDateOfNextTimeWindow(date: Date, in timeZone: TimeZone = .current) -> Date {
        let dateRange = dateRange(containing: date, in: timeZone)
        return dateRange.upperBound
    }

}

private extension Date {

    func startOfWeek(in timeZone: TimeZone) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        var components = calendar.dateComponents([.weekday, .year, .month, .weekOfYear], from: self)
        components.weekday = calendar.firstWeekday

        var date = calendar.date(from: components)
        date = date?.addingTimeInterval(TimeInterval(timeZone.secondsFromGMT()))
        return date
    }

    func endOfWeek(in timeZone: TimeZone) -> Date? {
        guard let startOfWeek = startOfWeek(in: timeZone) else {
            return nil
        }

        return Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)
    }

}
