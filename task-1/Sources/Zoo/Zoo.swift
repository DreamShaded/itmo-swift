import Foundation

final class Zoo {
    private(set) var animals: [Animal] = []
    private var rng: SeededGenerator

    private let foodChance: Int
    private let maxPopulation: Int

    private var offspringCounters: [String: Int] = [:]

    private var day = 0

    init(seed: UInt64 = 42, foodChance: Int = 65, maxPopulation: Int = 40) {
        self.rng = SeededGenerator(seed: seed)
        self.foodChance = foodChance
        self.maxPopulation = maxPopulation
    }

    func addAnimal(_ animal: Animal) {
        animals.append(animal)
    }

    private func removeDeadAnimals() {
        animals.removeAll { !$0.isAlive }
    }

    private func nextOffspringName(species: String) -> String {
        let n = (offspringCounters[species] ?? 0) + 1
        offspringCounters[species] = n
        return "#\(n)"
    }

    func runIteration() {
        day += 1
        print("=== День \(day) ===\n")

        var newborns: [Animal] = []
        var births = 0
        var deaths = 0

        for animal in animals {
            guard animal.isAlive else { continue }

            animal.growOlder()
            print("\(animal.species) \(animal.name) \(animal.grewVerb). Возраст: \(animal.age).")

            if rng.happens(foodChance) {
                animal.eat()
                print("\(animal.species) \(animal.name) \(animal.ateVerb).")
            } else {
                animal.starve()
                print("\(animal.species) \(animal.name) \(animal.noFoodVerb). Уровень голода: \(animal.hunger).")
            }

            if animal.isDead() {
                let reason = animal.deathReason()
                animal.die()
                deaths += 1
                print("\(animal.species) \(animal.name) \(animal.diedVerb) \(reason).")
                print("")
                continue
            }

            let hasRoom = animals.count + newborns.count < maxPopulation
            if hasRoom,
               let child = animal.tryReproduce(using: &rng,
                                               nameProvider: { self.nextOffspringName(species: $0) }) {
                newborns.append(child)
                births += 1
                print("\(animal.species) \(animal.name) \(animal.bredVerb): \(child.species) \(child.name).")
            }

            print("")
        }

        removeDeadAnimals()
        animals.append(contentsOf: newborns)

        printDailyStatistics(births: births, deaths: deaths)
    }

    func runSimulation(iterations: Int) {
        for _ in 1...iterations {
            guard !animals.isEmpty else {
                print("В зоопарке не осталось животных. Симуляция завершена.\n")
                break
            }
            runIteration()
        }
        printFinalStatistics()
    }

    private func countsBySpecies() -> [(species: String, count: Int)] {
        var counts: [String: Int] = [:]
        for animal in animals {
            counts[animal.species, default: 0] += 1
        }
        return counts.sorted { $0.key < $1.key }.map { (species: $0.key, count: $0.value) }
    }

    private func printDailyStatistics(births: Int, deaths: Int) {
        print("Статистика:")
        print("Всего животных: \(animals.count)")
        print("Родилось за день: \(births)")
        print("Умерло за день: \(deaths)")
        for entry in countsBySpecies() {
            print("  \(entry.species): \(entry.count)")
        }
        print("")
    }

    private func printFinalStatistics() {
        print("===== Итоги симуляции =====")
        print("Прошло дней: \(day)")
        print("Осталось животных: \(animals.count)")
        if animals.isEmpty { return }
        for entry in countsBySpecies() {
            print("  \(entry.species): \(entry.count)")
        }
        print("\nОставшиеся животные:")
        for animal in animals {
            animal.printInfo()
        }
    }
}
