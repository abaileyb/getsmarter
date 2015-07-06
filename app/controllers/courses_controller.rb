class CoursesController < ApplicationController
	def index
		courselist = getCourseIdsByUserId(2667)
		Course.delete_all
		courselist.each do |course|
			Course.create(name: course[1], cid: course[0])
		end
		@courses = Course.all
	end

	def show
		@course = Course.find(params[:id])
		@name_array = []
		@id_array = getAssignmentIdsByCourseId(@course.cid, @name_array)

		@grade_hash = getUsersGradesFromAssignmentsAndID(@id_array, 2667)
	end





	private
	def getCourseIdsByUserId(id)
		rest_data = RestClient.get 'https://testing.vle.getsmarter.co.za/webservice/rest/server.php?wstoken=0d1b35e7065c79172a800a0edf1cc080&wsfunction=core_enrol_get_users_courses&userid=10435&moodlewsrestformat=json'
		json_data = JSON.load rest_data	
		puts json_data
		empty_table = Array.new(json_data.size) { Array.new(2) }
		count = 0 
		puts empty_table
		json_data.each do |course|
			empty_table[count][0] = course['id']
			empty_table[count][1] = course['fullname']
			count +=1
		end
		return empty_table
	end

	def getAssignmentIdsByCourseId(cid, namearray)
		rest_data = RestClient.get "https://testing.vle.getsmarter.co.za/webservice/rest/server.php?wstoken=0d1b35e7065c79172a800a0edf1cc080&wsfunction=mod_assign_get_assignments&courseids[0]=#{cid}&moodlewsrestformat=json"
		json_data = JSON.load rest_data	

		puts json_data
		assignments = json_data["courses"][0]["assignments"]

		assignmentids = []

		assignments.each do |assignment|
			assignmentids << assignment["id"]
			namearray << assignment["name"]
		end

	assignmentids #returns an array of assignment ids
end


	##TODO: REFACTOR THIS FUNCTION TO BE MUCH MORE EFFICENT
	# def getUsersGradesFromAssignmentsAndID(assignmentids, uid)
	# 	usersgrades = {}
	# 	addurl = ""
	# 	assignmentids.each do |assignmentid|


	# 		rest_data = RestClient.get "https://testing.vle.getsmarter.co.za/webservice/rest/server.php?wstoken=0d1b35e7065c79172a800a0edf1cc080&wsfunction=mod_assign_get_grades&assignmentids[0]=#{assignmentid}&moodlewsrestformat=json"
	# 		json_data = JSON.load rest_data	

	# 		puts ''
	# 		puts ''
	# 		puts json_data

	# 		if (!json_data["assignments"].empty?)
	# 			grades = json_data["assignments"][0]["grades"]


	# 			grades.each do |grade|
	# 				if grade["userid"] == uid
	# 					usersgrades[assignmentid] = grade["grade"]
	# 				end
	# 			end

	# 		end

	# 	end

	# 	return usersgrades
	# end	



	def getUsersGradesFromAssignmentsAndID(assignmentids, uid)
		usersgrades = {}

		puts assignmentids

		addurl = ""
		count = 0
		assignmentids.each do |assignmentid|
			addurl << "&assignmentids[#{count}]=#{assignmentid}"
			count += 1
		end

		resturl = "https://testing.vle.getsmarter.co.za/webservice/rest/server.php?wstoken=0d1b35e7065c79172a800a0edf1cc080&wsfunction=mod_assign_get_grades&moodlewsrestformat=json" + addurl
		rest_data = RestClient.get resturl
		json_data = JSON.load rest_data	

		puts 'JSON STARTS HERE'
		puts json_data

		assignment_data = json_data["assignments"]



		assignment_data.each do |assignment|


			assignmentid = assignment["assignmentid"]
			grades = assignment["grades"]

			grades.each do |grade|
				if grade["userid"] == uid
					usersgrades[assignmentid] = grade["grade"]
				end
			end

		end

		return usersgrades
	end	


end
