import Foundation

final class Wolf: Animal {
    init(name: String) {
        super.init(name: name, species: "Волк", gender: .masculine,
                   maxAge: 12, hungerLimit: 5, foodNeed: 2,
                   reproductionChance: 10, maturityAge: 2)
    }
    override func makeOffspring(name: String) -> Animal { Wolf(name: name) }
}

final class Bear: Animal {
    init(name: String) {
        super.init(name: name, species: "Медведь", gender: .masculine,
                   maxAge: 20, hungerLimit: 6, foodNeed: 3,
                   reproductionChance: 8, maturityAge: 4)
    }
    override func makeOffspring(name: String) -> Animal { Bear(name: name) }
}

final class Cat: Animal {
    init(name: String) {
        super.init(name: name, species: "Кошка", gender: .feminine,
                   maxAge: 10, hungerLimit: 4, foodNeed: 1,
                   reproductionChance: 20, maturityAge: 2)
    }
    override func makeOffspring(name: String) -> Animal { Cat(name: name) }
}

final class Fox: Animal {
    init(name: String) {
        super.init(name: name, species: "Лиса", gender: .feminine,
                   maxAge: 9, hungerLimit: 4, foodNeed: 2,
                   reproductionChance: 18, maturityAge: 2)
    }
    override func makeOffspring(name: String) -> Animal { Fox(name: name) }
}

final class Chicken: Animal {
    init(name: String) {
        super.init(name: name, species: "Курица", gender: .feminine,
                   maxAge: 6, hungerLimit: 3, foodNeed: 1,
                   reproductionChance: 35, maturityAge: 1)
    }
    override func makeOffspring(name: String) -> Animal { Chicken(name: name) }
}
