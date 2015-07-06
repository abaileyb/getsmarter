module CoursesHelper
	def gradeify(grade)
		if grade
			return (grade.chop!.chop!.chop!) + "%"
		else
			return ("No Grade")
		end
	end

	
end
