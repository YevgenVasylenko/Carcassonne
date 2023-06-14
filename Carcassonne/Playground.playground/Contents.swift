let originalArray = [1, 2, 3, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5]
var elementCount = [Int: Int]()

// Count the occurrences of each element
for element in originalArray {
    elementCount[element, default: 0] += 1
}

// Find the maximum count
let maxCount = elementCount.values.max() ?? 0

// Filter elements with count greater than or equal to maxCount
let resultArray = elementCount.filter { $0.value >= maxCount }.map { $0.key }

print(resultArray) // Output: [5]

