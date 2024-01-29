let firstMan = (name: "Вася", surname: "Попов", age: 25, cityOfOrigin: "Moscow")
let secondMan = (name: "Лера", surname: "Иванова", age: 16, cityOfOrigin: "Voronezh")

firstMan.age
secondMan.0
firstMan.3
secondMan.cityOfOrigin

var monthOfYears = ["январь","февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"]
for monthOfYear in monthOfYears {
    print(monthOfYear)
}
var days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
for day in days {
    print(day)
}

//var daysInMonths = [String]()
//for i in 0..<monthOfYears.count {
 //   daysInMonths.append(monthOfYears[i])
 //   daysInMonths.append(String(days[i]))
//}
//for daysInMonth in daysInMonths {
 //   print(daysInMonth)
//}

for i in 0..<monthOfYears.count {
    print("\(monthOfYears[i]) \(days[i])")
}
    
struct DaysInMonth {
    let nameOfMonth: String
    let numberOfDays: Int
}
var cortegeOfMonths = [
    DaysInMonth(nameOfMonth: "январь", numberOfDays: 31),
    DaysInMonth(nameOfMonth: "февраль", numberOfDays: 28),
    DaysInMonth(nameOfMonth: "март", numberOfDays: 31),
    DaysInMonth(nameOfMonth: "апрель", numberOfDays: 30),
    DaysInMonth(nameOfMonth: "май", numberOfDays: 31),
    DaysInMonth(nameOfMonth: "июнь", numberOfDays: 30),
    DaysInMonth(nameOfMonth: "июль", numberOfDays: 31),
    DaysInMonth(nameOfMonth: "август", numberOfDays: 31),
    DaysInMonth(nameOfMonth: "сентябрь", numberOfDays: 30),
    DaysInMonth(nameOfMonth: "октябрь", numberOfDays: 31),
    DaysInMonth(nameOfMonth: "ноябрь", numberOfDays: 30),
    DaysInMonth(nameOfMonth: "декабрь", numberOfDays: 31)
]
for DaysInMonth in cortegeOfMonths {
   print(DaysInMonth)
}

let reversedDays = days.reversed()
for day in reversedDays {
    print(day)
}

let reversedCortageOfMonth = cortegeOfMonths.reversed()
for DaysInMonth in reversedCortageOfMonth {
    print(DaysInMonth)
}
var numberOfMonth: Int = 3
var dateOfMonth: Int = 28
let daysToEnd = days.dropFirst(numberOfMonth)
let NumberDaysInMonths = daysToEnd.reduce(0, +)
let daysToEndOfMonth = days[numberOfMonth-1]-dateOfMonth
print(daysToEndOfMonth+NumberDaysInMonths)

var students: [String: Int] = ["Иван Иванов": 4, "Петр Петров": 3, "Алексей Алексеев": 2]
students.updateValue(5, forKey: "Иван Иванов")

for student in students {
    if student.value >= 3 {
        print("\(student.key), Поздравляем! Вы сдали экзамен.")
    }else{
        print("\(student.key), вы не сдали экзамен. Отправляйтесь на пересдачу!")
    }
}

students["Катя Сиорова"] = 4
students["Маша Миронова"] = 5
students["Оля Волкова"] = 5
print(students)

for student in students {
    if student.value <= 2 {
        students.removeValue(forKey: "\(student.key)")
        print("Студент \(student.key) отчислен")
    }
}

var middlePoint: Double = 0
var sumPoint = 0
for student in students {
    sumPoint = (sumPoint + student.value)
}
middlePoint = Double(sumPoint)/Double(students.count)
print("Средний балл групы студентов по итогам экзамена составляет \(middlePoint) баллов.")

