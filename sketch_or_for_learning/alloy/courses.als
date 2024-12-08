open util/ordering[Grade]
// http://alloy4fun.inesctec.pt/Z3SaBk4fvFEicsWwc

sig Person {
	teaches : set Course,
	enrolled : set Course,
	projects : set Project
}

sig Professor,Student in Person {}

sig Course {
	projects : set Project,
	grades : Person -> Grade
}

sig Project {}

sig Grade {}
// Specify the following properties.
// You can check their correctness with the different commands and
// when specifying each property you can assume all the previous ones to be true.

pred inv1 {
	// Only students can be enrolled in courses
	enrolled.Course in Student
}


pred inv2 {
	// Only professors can teach courses
          teaches.Course in Professor
}


pred inv3 {
	// Courses must have teachers
          all c : Course | some teaches.c
}


pred inv4 {
	// Projects are proposed by one course
          Course<:projects in Course one -> Project
}


pred inv5 {
	// Only students work on projects and 
	// projects must have someone working on them
           Person<:projects.Project in Student
           all p : Project | some Person<:projects.p
}


pred inv6 {
	// Students only work on projects of courses they are enrolled in
          all s : Student | s.projects in s.enrolled.projects
}


pred inv7 {
	// Students work on at most one project per course
          all s : Student, c : s.enrolled | lone s.(Person<:projects) & c.projects
}


pred inv8 {
	// A professor cannot teach herself
          all p : Professor | no p.enrolled & p.teaches
}


pred inv9 {
	// A professor cannot teach colleagues
          //all c : Course | no enrolled.c & teaches.c
          // ???? ne vem kaj zahteva...
}


pred inv10 {
	// Only students have grades
          grades in Course -> Student -> Grade
}


pred inv11 {
	// Students only have grades in courses they are enrolled
          all s : Student, c : Course | some s.(c.grades) implies c in s.enrolled
}


pred inv12 {
	// Students have at most one grade per course
          all s : Student, c : s.enrolled | lone c.grades[s]
}


pred inv13 {
	// A student with the highest mark in a course must have worked on a project on that course
           all s : Student, c : s.enrolled |
             (all g : c.grades[Student] | g.lte[c.grades[s]])
             implies
             some c.projects & s.projects
          // ne vem zakaj je narobe... protiprimer se mi zdi napačen...
         // http://alloy4fun.inesctec.pt/xc6fgropxMG87JweY
}


pred inv14 {
	// A student cannot work with the same student in different projects
          all s : Student, p : s.projects, s1 : (Student<:projects).p | s1!=s implies no (s1.projects&s.projects)-p
}


pred inv15 {
	// Students working on the same project in a course cannot have marks differing by more than one unit
          // spustim, ker še nisem jemal ordering...
}

run ex {
inv1
inv2
inv3
inv4
inv5
inv6
inv7
inv8
inv9
inv10
inv11
inv12
inv13
inv14
inv15
#grades>3
}
