enum baseErrors: Error {
    case BadRequest
    case NotFound
    case InternalServerError
}
var BadReques: Int? = nil
var NotFound: Int? = 404
var InternalServerError: Int? = nil

do 	{
    if BadReques == 400 {
        throw baseErrors.BadRequest
    }
    if NotFound == 404 {
        throw baseErrors.NotFound
    }
    if InternalServerError == 500 {
        throw baseErrors.InternalServerError
    }
} catch baseErrors.BadRequest {
    print("Некорректный запрос")
} catch baseErrors.NotFound {
    print("Страница не найдена")
} catch baseErrors.InternalServerError {
    print("Внутренняя ошибка сервера")
}

func isAnyError () throws {
    if BadReques == 400 {
        throw baseErrors.BadRequest
    }
    if NotFound == 404 {
        throw baseErrors.NotFound
    }
    if InternalServerError == 500 {
        throw baseErrors.InternalServerError
    }
}

do {
    try isAnyError()
} catch baseErrors.BadRequest {
    print("Некорректный запрос")
} catch baseErrors.NotFound {
    print("Страница не найдена")
} catch baseErrors.InternalServerError {
    print("Внутренняя ошибка сервера")
}

func compareTypes<T, R>(a: T, b: R) -> Void {
    if type(of: T.self) == type(of: R.self) {
        print("Yes")
    } else {
        print("No")
    }
}
compareTypes(a: 5, b: 3)

enum typeExeptions: Error {
    case yes
    case no
}
var T = 5
var R = 2.5
do {
    if type(of: T.self) == type(of: R.self) {
        throw typeExeptions.yes
    } else {
        throw typeExeptions.no
    }
} catch typeExeptions.yes {
    print("Переменные одинакового типа")
} catch typeExeptions.no {
    print("Тип переменных разный")
}

func compareObjects<T, R>(a: T, b: R) -> Void {
    if T.self == R.self {
        print("Значения равны")
    } else {
        print("Значения не равны")
    }
}
compareObjects(a: 5, b: 5)
