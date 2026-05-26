import Foundation

enum Gender {
    case masculine
    case feminine
}

class Animal {
    let name: String
    let species: String
    let gender: Gender

    var age: Int
    let maxAge: Int

    var hunger: Int
    let hungerLimit: Int

    let foodNeed: Int

    let reproductionChance: Int

    let maturityAge: Int

    private(set) var isAlive: Bool = true

    init(name: String,
         species: String,
         gender: Gender,
         maxAge: Int,
         hungerLimit: Int,
         foodNeed: Int,
         reproductionChance: Int,
         maturityAge: Int) {
        self.name = name
        self.species = species
        self.gender = gender
        self.age = 0
        self.maxAge = maxAge
        self.hunger = 0
        self.hungerLimit = hungerLimit
        self.foodNeed = foodNeed
        self.reproductionChance = reproductionChance
        self.maturityAge = maturityAge
    }

    func eat() {
        hunger = max(0, hunger - foodNeed)
    }

    func starve() {
        hunger += foodNeed
    }

    func growOlder() {
        age += 1
    }

    func isDead() -> Bool {
        age > maxAge || hunger >= hungerLimit
    }

    func deathReason() -> String {
        age > maxAge ? "от старости" : "от голода"
    }

    func die() {
        isAlive = false
    }

    func isMature() -> Bool {
        isAlive && age >= maturityAge
    }

    func tryReproduce(using rng: inout SeededGenerator,
                      nameProvider: (String) -> String) -> Animal? {
        guard isMature(), rng.happens(reproductionChance) else { return nil }
        return makeOffspring(name: nameProvider(species))
    }

    func makeOffspring(name: String) -> Animal {
        fatalError("makeOffspring(name:) должен быть переопределён в наследнике \(species)")
    }

    func printInfo() {
        let status = isAlive ? "жив" : "мёртв"
        print("\(species) \(name) — возраст \(age)/\(maxAge), голод \(hunger)/\(hungerLimit), \(status)")
    }

    // спасибо клодычу за форматирование
    var grewVerb: String { gender == .feminine ? "стала старше" : "стал старше" }
    var ateVerb: String { gender == .feminine ? "поела" : "поел" }
    var noFoodVerb: String { gender == .feminine ? "не нашла еду" : "не нашёл еду" }
    var diedVerb: String { gender == .feminine ? "умерла" : "умер" }
    var bredVerb: String { gender == .feminine ? "принесла потомка" : "принёс потомка" }
}
