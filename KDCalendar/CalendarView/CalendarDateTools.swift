//
//  CalendarDateLocal.swift
//  CalendarView
//
//  Created by mby on 2020/4/21.
//  Copyright © 2020 Karmadust. All rights reserved.
//

import Foundation

class CalendarDateTools: NSObject {
    static let `default` = CalendarDateTools()
    
    ///公历
    fileprivate lazy var calendar:Calendar? = {
        var tempCalendar = Calendar(identifier: .gregorian)
        tempCalendar.timeZone = NSTimeZone.system
        return tempCalendar
    }()
    fileprivate lazy var chineseCalendar:Calendar? = {
        var temp = Calendar(identifier: .chinese)
        temp.timeZone = NSTimeZone.system
        return temp
    }()

    fileprivate lazy var formatter:DateFormatter? = {
        let tempFor = DateFormatter()
        tempFor.timeZone = NSTimeZone.system
        tempFor.dateFormat = "yyyy-MM-dd"
        return tempFor
    }()
    
    fileprivate lazy var lunarZodiocArr:[String] = {
       let zodiacArr = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊","猴", "鸡", "狗", "猪",]
        return zodiacArr
    }()
    
    fileprivate lazy var lunarYearArr:[String] = {
        let year = ["甲子","乙丑","丙寅","丁卯","戊辰","己巳","庚午","辛未","壬申","癸酉","甲戌","乙亥","丙子","丁丑","戊寅","己卯","庚辰","辛己","壬午","癸未","甲申","乙酉","丙戌","丁亥","戊子","己丑","庚寅","辛卯","壬辰","癸巳","甲午","乙未","丙申","丁酉","戊戌","己亥","庚子","辛丑","壬寅","癸丑","甲辰","乙巳","丙午","丁未","戊申","己酉","庚戌","辛亥","壬子","癸丑","甲寅","乙卯","丙辰","丁巳","戊午","己未","庚申","辛酉","壬戌","癸亥"]
        return year
    }()
    
    fileprivate lazy var lunarMonthArr:[String] = {
        let month = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月","九月", "十月", "冬月", "腊月"]
        return month
    }()
    
    fileprivate lazy var lunarDaysArr:[String] = {
        let days =
            ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        return days
    }()
    
    override init() {
        super.init()
    }
    
    /// 获取当前日期的天数
    ///
    /// - Parameter date: 返回当月的天数
    static public func getNumberOfDaysInMonth(_ date:Date) -> Int {
        let range = CalendarDateTools.default.calendar?.range(of: .day, in: .month, for: date)
        return (range?.count)!
    }
    
    /// 获取日期当天周几
    ///
    /// - Parameter date: 传入的日期
    /// - Returns: 返回周几
    static public func getWeekdayWithDate(_ date:Date) -> Int{
        let comp = CalendarDateTools.default.calendar?.component(.weekday, from: date)
        ///1 周日 2 周一 3 周二 一次类推 1-7 改为 0-6方便计算
        return comp! - 1
    }
    
    
    /// 根据date获取指定偏移天数的date
    ///
    /// - Parameters:
    ///   - date: 指定的日期
    ///   - offSetDays: 偏移的天数 负数向前 正数向后
    /// - Returns: 返回偏移后的日期
    static public func getDateFrom(_ date:Date,offSetDays:Int) ->Date{
        var lastMonthComps = DateComponents()
        lastMonthComps.day = offSetDays
        return (CalendarDateTools.default.calendar?.date(byAdding: lastMonthComps, to: date))!
    }
    
    /// 根据date获取指定偏移月数的date
    ///
    /// - Parameters:
    ///   - date: 指定的日期
    ///   - offSetDays: 偏移的月数 负数向前 正数向后
    /// - Returns: 返回偏移后的日期
    static public func getDateFrom(_ date:Date,offSetMonths:Int) ->Date{
        
        var lastMonthComps = DateComponents()
        lastMonthComps.month = offSetMonths
        return (CalendarDateTools.default.calendar?.date(byAdding: lastMonthComps, to: date))!
    }
    
    /// 根据date获取指定偏移年数的date
    ///
    /// - Parameters:
    ///   - date: 指定的日期
    ///   - offSetDays: 偏移的年数 负数向前 正数向后
    /// - Returns: 返回偏移后的日期
    static public func getDateFrom(_ date:Date,offSetYears:Int) ->Date{
        
        var lastMonthComps = DateComponents()
        lastMonthComps.year = offSetYears
        return (CalendarDateTools.default.calendar?.date(byAdding: lastMonthComps, to: date))!
    }
    
    
    /// 获取每月的第一天周几
    ///
    /// - Parameter date: 传入日期
    /// - Returns: 返回这个月第一天周几
    static public func convertDateToFirstWeek(_ date:Date) -> Int {
        let firstDayOfMonthDate = getFirstDayOfMonth(date)
        let firstWeekday = CalendarDateTools.getWeekdayWithDate(firstDayOfMonthDate)
        return firstWeekday
    }
    
    
    /// 根据传入的日期获取日期中月份的第一天
    ///
    /// - Parameter date: 日期
    /// - Returns: 返回第一天的日期
    static public func getFirstDayOfMonth(_ date:Date) -> Date {
        CalendarDateTools.default.calendar?.firstWeekday = 1
        var comp = CalendarDateTools.default.calendar?.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second,Calendar.Component.weekday], from: date)
        comp?.day = 1
        let firstDayOfMonthDate = CalendarDateTools.default.calendar?.date(from: comp!)
        return firstDayOfMonthDate!

    }
    
    static public func getLunarDay (date:Date) -> String {
        let localComp =  CalendarDateTools.default.chineseCalendar!.dateComponents([.day], from: date)
         return CalendarDateTools.default.lunarDaysArr[localComp.day!-1]
    }
    
    /// 根据q日期返回这一个月的日期
    ///
    /// - Parameter date: 传入的日期
    /// - Returns: 返回的这个月的日期
    static public func getAllMonthDays(_ date:Date , maxDate:Date? = nil , minDate:Date? = nil) -> [CalendarDayModel] {
        //本月总天数
        let currentMonthDays = CalendarDateTools.getNumberOfDaysInMonth(date)
        //本月第一天周几
        let firstWeekDay = CalendarDateTools.convertDateToFirstWeek(date)
        //本月的第一天
        let firstDay = CalendarDateTools.getFirstDayOfMonth(date)
        
        //上个月的同一天日期
        let lastMonthDate = CalendarDateTools.getDateFrom(date, offSetMonths: -1)
        //上个月的天数
        let lastMonthDays = CalendarDateTools.getNumberOfDaysInMonth(lastMonthDate)
        //这个月要保留几天上个月的位置
        
        var rang = [Int]()
        if firstWeekDay != 0{
            rang = Array((lastMonthDays-firstWeekDay+1)...lastMonthDays)
        }
        
        //日期固定为42个，一共要添加多少按着下面的计算
        var timeArr = [Date]()
        //获取上月要显示的日期
        if rang.count > 0 {
            for i in 1...rang.count {
                let tempDate = CalendarDateTools.getDateFrom(firstDay, offSetDays: -i)
                timeArr.insert(tempDate, at: 0)
            }
        }
        //获取本月的所有日期
        for i in 0..<currentMonthDays{
            let tempDate = CalendarDateTools.getDateFrom(firstDay, offSetDays: i)
            timeArr.append(tempDate)
        }
        
        //下个月的日期,默认展示42个方格，6*7
        let futureDays = 42 - (rang.count + currentMonthDays)
        let futureFirstDate = timeArr.last!
        for i in 1...futureDays{
            let tempDate = CalendarDateTools.getDateFrom(futureFirstDate, offSetDays: i)
            timeArr.append(tempDate)
        }
        //获取的数据，模型转化
        var modelArr = [CalendarDayModel]()
        for time in timeArr {
            var model = CalendarDayModel()
            model.date = time
//            model.dateStr = time.stringWithFormat()
//            model.year = time.year!
//            model.month = time.month!
//            model.day = time.day!
            //判断是否是当天
            if CalendarDateTools.default.calendar!.isDate(time, inSameDayAs: Date()){
                model.isToday = true
            }
            let localComp =  CalendarDateTools.default.chineseCalendar!.dateComponents([.year,.month,.day,.hour,.minute,.second], from: time)
           
            model.lunarDay = CalendarDateTools.default.lunarDaysArr[localComp.day!-1]
            modelArr.append(model)
        }
        return modelArr
    }
}


struct CalendarDayModel {
    
    var dateStr = ""
    var date:Date?
    var year = 0
    var month = 0
    var day = 0
    /// 阴历日
    var lunarDay = ""
    /// 是否可以选,默认是不可选的
    var isCanSelected = false
    /// 是否是当天
    var isToday = false
    /// 是否展示阴历
}
