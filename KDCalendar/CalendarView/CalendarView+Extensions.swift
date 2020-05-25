/*
 * KDCalendarView.swift
 * Created by Michael Michailidis on 24/10/2017.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit
import EventKit

extension EKEvent {
    var isOneDay : Bool {
        let components = Calendar.current.dateComponents([.era, .year, .month, .day], from: self.startDate, to: self.endDate)
        return (components.era == 0 && components.year == 0 && components.month == 0 && components.day == 0)
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }
}

extension Date {
    func convertToTimeZone(from fromTimeZone: TimeZone, to toTimeZone: TimeZone) -> Date {
         let delta = TimeInterval(toTimeZone.secondsFromGMT(for: self) - fromTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
    
    func Year() -> Int {
         return Calendar.current.component(.year, from: self)
     }
    
     func Month() -> Int {
         return Calendar.current.component(.month, from: self)
     }
    
     func Day() -> Int {
         return Calendar.current.component(.day, from: self)
     }
    
     func Hour() -> Int {
         return Calendar.current.component(.hour, from: self)
     }
    
     func Minute() -> Int {
         return Calendar.current.component(.minute, from: self)
     }
    
     //18
     func Second() -> Int {
         return Calendar.current.component(.second, from: self)
     }
    
    var withoutTime: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.timeZone = TimeZone.current
        let date = calendar.date(from: components)
        return date ?? self
    }
}



