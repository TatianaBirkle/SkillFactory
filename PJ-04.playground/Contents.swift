protocol UserData {
  var userName: String { get }
  var userCardId: String { get }
  var userCardPin: Int { get }
  var userPhone: String { get }
  var userCash: Double { get set }
  var userDeposit: Double { get set }
  var userPhoneBalance: Double { get set }
  var userCardBalance: Double { get set }
}

enum UserActions {
    case orderCardBalance
    case orderDepositBalance
    case getCashfromCard(howMuchGetFromCard: Double)
    case getCashfromDeposit(howMuchGetFromDeposit: Double)
    case putCashToCard(howMuchPutToCard: Double)
    case putCashToDeposit(howMuchPutToDeposit: Double)
    case topUpPhoneBalanceFromCard(howMuchTopUpFromCard: Double)
    case topUpPhoneBalanceFromDeposit(howMuchTopUpFromDeposit: Double)
}

enum DescriptionTypesAvailableOperations: String {
    case cardBalace = "Вы выбрали операцию остаток на карте"
    case depositBalace = "Вы выбрали операцию остаток по депозиту"
    case cashFromCard = "Вы выбрали снятие наличных с карты"
    case cashFromDeposit = "Вы выбрали снятие наличных с депозита"
    case cashToCard = "Вы выбрали внести наличные на карту"
    case cashToDeposit = "Вы выбрали внести наличные на депозит"
    case topUpPhoneFromCard = "Вы выбрали пополнить телефон с карты"
    case topUpPhoneBFromDeposit = "Вы выбрали пополнить телефон с депозита"
 
}

enum PaymentMethod {
    case cash(cash: Double)
    case deposit(deposit: Double)
}

enum TextErrors: String {
    case incorrectCardOrPin = "Неверный номер карты или ПИН"
    case incorrectPhoneNumber = "Неверный номер телефона"
    case notEnoughCardCash = "Недостаточно средств на карте"
    case notEnoughDepositCash = "Недостаточно средств на депозите"
}

protocol BankApi {
    func showUserCardBalance()
    func showUserDepositBalance()
    func showUserToppedUpMobilePhoneDeposit(deposit: Double)
    func showUserToppedUpMobilePhoneCard(card: Double)
    func showWithdrawalCard(cash: Double)
    func showWithdrawalDeposit(cash: Double)
    func showTopUpCard(cash: Double)
    func showTopUpDeposit(cash: Double)
    func showError(error: TextErrors)
 
    func checkUserPhone(phone: String) -> Bool
    func checkMaxUserCard(withdraw: Double) -> Bool
    func checkMaxUserDeposit(withdraw: Double) -> Bool
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool
 
    mutating func topUpPhoneBalanceDeposit(pay: Double)
    mutating func topUpPhoneBalanceCard(pay: Double)
    mutating func getCashFromDeposit(cash: Double)
    mutating func getCashFromCard(cash: Double)
    mutating func putCashDeposit(topUp: Double)
    mutating func putCashCard(topUp: Double)
}

class ATM {
    private let userCardId: String
    private let userCardPin: Int
    private var someBank: BankApi
    private let action: UserActions
    private let userPhone: String
    private let paymentMethod: PaymentMethod?
    
    init(userCardId: String, userCardPin: Int, someBank: BankApi, action: UserActions, userPhone: String, paymentMethod: PaymentMethod? = nil) {
        
        self .userCardId = userCardId
        self .userCardPin = userCardPin
        self .someBank = someBank
        self .action = action
        self .userPhone = userPhone
        self .paymentMethod = paymentMethod
        
        sendUserDataToBank(userCardId: userCardId, userCardPin: userCardPin, actions: action, userPhone: userPhone, payment: paymentMethod)
    }
    
    public final func sendUserDataToBank(userCardId: String, userCardPin: Int, actions: UserActions, userPhone:String, payment: PaymentMethod?) {
        let isUserExist = someBank.checkCurrentUser(userCardId: userCardId, userCardPin: userCardPin)
        if isUserExist {
            switch actions {
            case .orderCardBalance:
                someBank.showUserCardBalance()
            case .orderDepositBalance:
                someBank.showUserDepositBalance()
            case let .getCashfromCard(howMuchGetFromCard: payment):
                if someBank.checkMaxUserCard(withdraw: payment) {
                    someBank.getCashFromCard(cash: payment)
                    someBank.showWithdrawalCard(cash: payment)
                }else{
                    someBank.showError(error: .notEnoughCardCash)
                }
            case let .getCashfromDeposit(howMuchGetFromDeposit: payment):
                if someBank.checkMaxUserDeposit(withdraw: payment) {
                    someBank.getCashFromDeposit(cash: payment)
                    someBank.showWithdrawalDeposit(cash: payment)
                }else{
                    someBank.showError(error: .notEnoughDepositCash)
                }
            case let .putCashToCard(howMuchPutToCard: payment):
                someBank.putCashCard(topUp: payment)
                someBank.showTopUpCard(cash: payment)
            case let .putCashToDeposit(howMuchPutToDeposit: payment):
                someBank.putCashDeposit(topUp: payment)
                someBank.showTopUpDeposit(cash: payment)
            case let .topUpPhoneBalanceFromCard(howMuchTopUpFromCard: payment):
                if someBank.checkMaxUserCard(withdraw: payment) {
                    if someBank.checkUserPhone(phone: userPhone){
                        someBank.topUpPhoneBalanceCard(pay: payment)
                        someBank.showUserToppedUpMobilePhoneCard(card: payment)
                    }else{
                        someBank.showError(error: .incorrectPhoneNumber)
                    }
                }else{
                    someBank.showError(error: .notEnoughCardCash)
                }
            case let .topUpPhoneBalanceFromDeposit(howMuchTopUpFromDeposit: payment):
                if someBank.checkMaxUserDeposit(withdraw: payment) {
                    if someBank.checkUserPhone(phone: userPhone){
                        someBank.topUpPhoneBalanceDeposit(pay: payment)
                        someBank.showUserToppedUpMobilePhoneDeposit(deposit: payment)
                    }else{
                        someBank.showError(error: .incorrectPhoneNumber)
                    }
                }else{
                    someBank.showError(error: .notEnoughDepositCash)
                }
            }
            
        }else{
            someBank.showError(error: .incorrectCardOrPin)
        }
    }
}
struct BankServer: BankApi {
    private var user: UserData
    
    init(user: UserData) {
        self.user = user
    }
    func showUserCardBalance() {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.cardBalace.rawValue). Остаток на карте составляет \(user.userCardBalance) рублей.")
    }
    
    func showUserDepositBalance() {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.depositBalace.rawValue). Остаток по депозиту составляет \(user.userDeposit) рублей.")
    }
    
    func showUserToppedUpMobilePhoneDeposit(deposit: Double) {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.topUpPhoneBFromDeposit.rawValue). Теперь баланс вашего телефона составляет \(user.userPhoneBalance) рублей. Остаток по депозиту составляет \(user.userDeposit) рублей.")
    }
    
    func showUserToppedUpMobilePhoneCard(card: Double) {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.topUpPhoneFromCard.rawValue). Теперь баланс вашего телефона составляет \(user.userPhoneBalance) рублей. Остаток на карте составляет \(user.userCardBalance) рублей.")
    }
    
    func showWithdrawalCard(cash: Double) {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.cashFromCard.rawValue). Вы сняли с карты \(cash) рублей. Остаток на карте составляет \(user.userCardBalance) рублей.")
    }
    
    func showWithdrawalDeposit(cash: Double) {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.cashFromDeposit.rawValue). Вы сняли с депозита \(cash) рублей. Остаток по депозиту составляет \(user.userDeposit) рублей.")
    }
    
    func showTopUpCard(cash: Double) {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.cashToCard.rawValue). Вы пополнити карту на сумму \(cash) рублей. Остаток на карте составляет \(user.userCardBalance) рублей.")
    }
    
    func showTopUpDeposit(cash: Double) {
        print("Добрый день, \(user.userName)! \(DescriptionTypesAvailableOperations.cashToDeposit.rawValue). Вы пополнили депозит на сумму \(cash) рублей. Остаток по депозиту составляет \(user.userDeposit) рублей.")
    }
    
    func showError(error: TextErrors) {
        print("Добрый день, \(user.userName)! Ошибка: \(error.rawValue). Попробуйте ещё раз.")
    }
    
    func checkUserPhone(phone: String) -> Bool {
        if phone == user.userPhone {
            return true
        }else{
            return false
        }
    }
    
    func checkMaxUserCard(withdraw: Double) -> Bool {
        if user.userCardBalance >= withdraw {
            return true
        }else{
            return false
        }
    }
    
    func checkMaxUserDeposit(withdraw: Double) -> Bool {
        if user.userDeposit >= withdraw {
            return true
        }else{
            return false
        }
    }
    
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool {
        if user.userCardId == userCardId && user.userCardPin == userCardPin {
            return true
        }else{
            return false
        }
    }
    
    mutating func topUpPhoneBalanceDeposit(pay: Double) {
        user.userPhoneBalance += pay
        user.userDeposit -= pay
    }
    
    mutating func topUpPhoneBalanceCard(pay: Double) {
        user.userPhoneBalance += pay
        user.userCardBalance -= pay
    }
    
    mutating func getCashFromDeposit(cash: Double) {
        user.userDeposit -= cash
    }
    
    mutating func getCashFromCard(cash: Double) {
        user.userCardBalance -= cash
    }
    
    mutating func putCashDeposit(topUp: Double) {
        user.userDeposit += topUp
    }
    
    mutating func putCashCard(topUp: Double) {
        user.userCardBalance += topUp
    }
}

struct User: UserData {
    var userName: String
    var userCardId: String
    var userCardPin: Int
    var userPhone: String
    var userCash: Double
    var userDeposit: Double
    var userPhoneBalance: Double
    var userCardBalance: Double
}
    
let leontyev: UserData = User(
    userName: "Валерий Леонтьев",
    userCardId: "9999888877776666",
    userCardPin: 1234,
    userPhone: "+79067859944",
    userCash: 8500.00,
    userDeposit: 830000.00,
    userPhoneBalance: 1400.50,
    userCardBalance: 14683.35
)

let bankClient = BankServer(user: leontyev)

let ATM1 = ATM(
    userCardId: "9999888877776666",
    userCardPin: 1234,
    someBank: bankClient,
    action: .orderDepositBalance,
    userPhone: "+79067859944"
)
