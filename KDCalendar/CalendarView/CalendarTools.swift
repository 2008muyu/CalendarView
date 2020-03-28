//
//  CalendarTools.swift
//  CalendarView
//
//  Created by mby on 2020/3/28.
//  Copyright © 2020 Karmadust. All rights reserved.
//

import Foundation

open class CalendarTool {
    
    static func chineseYear (date:Date) -> String {
         let chineseYears: [String] = ["甲子","乙丑","丙寅","丁卯","戊辰","己巳","庚午","辛未","壬申","癸酉","甲戌","乙亥","丙子","丁丑","戊寅","己卯","庚辰","辛己","壬午","癸未","甲申","乙酉","丙戌","丁亥","戊子","己丑","庚寅","辛卯","壬辰","癸巳","甲午","乙未","丙申","丁酉","戊戌","己亥","庚子","辛丑","壬寅","癸丑","甲辰","乙巳","丙午","丁未","戊申","己酉","庚戌","辛亥","壬子","癸丑","甲寅","乙卯","丙辰","丁巳","戊午","己未","庚申","辛酉","壬戌","癸亥"]
        
        let localeCalendar: Calendar = Calendar(identifier: .chinese)
        let localeComp: DateComponents = localeCalendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        
        return chineseYears[localeComp.year!-1]
    }
    
    static func calculationChinaCalendar(date:Date, displayHoliday:Bool?=false) -> String {
        
//        var chineseYear : String?
//        var chineseMonth : String?
        let year : Int = {
            let y = Calendar.current.component(.year, from: Date())
           return y
        }()
        
        let strDateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd"
            return formatter
        }()
        
        let chineseMonths: [String] = ["正月","二月","三月","四月","五月","六月","七月","八月","九月","十月","冬月","腊月"]
        let chineseDays: [String] = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","廿十","廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]

        let localeCalendar: Calendar = Calendar(identifier: .chinese)
        let localeComp: DateComponents = localeCalendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        
        
        let m_str: String = chineseMonths[localeComp.month!-1]
//        chineseMonth = m_str
        let d_str: String = chineseDays[localeComp.day!-1]
        var chineseCal_str: String = d_str
        if(chineseMonths.contains(m_str) && d_str == "初一") {
            chineseCal_str = m_str
            if m_str == "正月" && d_str == "初一" {
                chineseCal_str = "春节"
            } else {
                chineseCal_str = "初一"
            }
        }else if m_str == "正月" && d_str == "十五" {
            chineseCal_str = "元宵节"
        } else if m_str == "五月" && d_str == "初五" {
            chineseCal_str = "端午节"
        } else if m_str == "七月" && d_str == "初七" {
            chineseCal_str = "七夕"
        } else if m_str == "七月" && d_str == "十五" {
            chineseCal_str = "中元节"
        } else if m_str == "八月" && d_str == "十五" {
            chineseCal_str = "中秋节"
        } else if m_str == "九月" && d_str == "初九" {
            chineseCal_str = "重阳节"
        } else if m_str == "腊月" && d_str == "初八" {
            chineseCal_str = "腊八节"
        } else if m_str == "腊月" && d_str == "廿三" {
            chineseCal_str = "小年"
        } else if m_str == "腊月" && d_str == "三十" {
            chineseCal_str = "除夕"
        }
        
        
        // 公历节日
        let Holidays: [String : String] = ["01-01":"元旦", "02-14":"情人节", "03-08":"妇女节", "03-12":"植树节", "04-01":"愚人节", "05-01":"劳动节", "05-04":"青年节", "06-01":"儿童节", "07-01":"建党节", "08-01":"建军节", "09-10":"教师节", "10-01":"国庆节", "12-24":"平安夜", "12-25":"圣诞节"]
        
        let nowStr = strDateFormatter.string(from: date)
        
        // 复活节, Meeus/Jones/Butcher算法
        let a: UInt = UInt(year % 19)
        let b: UInt = UInt(year / 100)
        let c: UInt = UInt(year % 100)
        let d: UInt = b/4
        let e: UInt = b%4
        let f: UInt = (b+8)/25
        let g: UInt = (b-f+1)/3
        let h: UInt = (19*a+b-d-g+15)%30
        let i: UInt = c/4
        let k: UInt = c%4
        let l: UInt = (32+(2*e)+(2*i)-h-k)%7
        let m: UInt = (a+(11*h)+(22*l))/451
        let theMonth: UInt = (h+l-(7*m)+114)/31
        let day: UInt = ((h+l-(7*m)+114)%31)+1
        let easter: String = "0\(theMonth)-\(day)"
        if easter == nowStr {
            chineseCal_str = "复活节"
        }
        
        if Holidays.keys.contains(nowStr) {
            chineseCal_str = Holidays[nowStr]!
        }
        // 公历礼拜节日
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([Calendar.Component.day,Calendar.Component.weekday,Calendar.Component.weekdayOrdinal,Calendar.Component.month, Calendar.Component.year], from: date)
        let month: Int = comps.month!
        let dayInMonth: Int = comps.day!
        
        switch month {
            case 5:
            
                if comps.weekdayOrdinal == 2 && comps.weekday == 1{
                chineseCal_str = "母亲节"
            }
            break
            case 6:
            
            if comps.weekdayOrdinal == 3 && comps.weekday == 1{
                chineseCal_str = "父亲节"
            }
            break
            case 11:
            
            if dayInMonth == 26 {
                chineseCal_str = "感恩节"
            }
            break
            default:
            
            break
        }
        
        if (displayHoliday == true) {// 需要显示假期&节日
            return chineseCal_str;
        }
        return d_str;
        
    }
}
