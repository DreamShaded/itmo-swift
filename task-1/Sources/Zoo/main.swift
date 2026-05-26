import Foundation

let zoo = Zoo(seed: 42, foodChance: 65, maxPopulation: 40)

zoo.addAnimal(Wolf(name: "Акела"))
zoo.addAnimal(Chicken(name: "Ряба"))
zoo.addAnimal(Cat(name: "Муся"))
zoo.addAnimal(Bear(name: "Боря"))
zoo.addAnimal(Fox(name: "Алиса"))

zoo.runSimulation(iterations: 15)
