
struct Student {
    let name: String
    var score: Int
}

let students: [Student] = [Student(name: "Jhon", score: 86),
                           Student(name: "Mikr", score: 76),
                           Student(name: "James", score: 65),
                           Student(name: "Anton", score: 95),
                           Student(name: "Roger", score: 73),
                           Student(name: "Scot", score: 80),
                           Student(name: "Obama", score: 90)]

var topStudentsFilter: (Student) -> Bool = { student in
    return student.score > 80
}

func topStudentsFilterF(student: Student) -> Bool {
    return student.score > 70
}

let topStudents = students.filter { $0.score > 80 }
let studentRanking = topStudents.sorted { $0.score > $1.score }

for student in studentRanking {
    print(student.name)
}
