class CoursesController < ApplicationController
	def index
		courselist = getCourseIdsByUserId(10453)
		Course.delete_all
		courselist.each do |course|
			Course.create(name: course[1], cid: course[0])
		end
		@courses = Course.all
	end

	def show
		
	end

	def getCourseIdsByUserId(id)
		rest_data = RestClient.get 'https://testing.vle.getsmarter.co.za/webservice/rest/server.php?wstoken=0d1b35e7065c79172a800a0edf1cc080&wsfunction=core_enrol_get_users_courses&userid=10435&moodlewsrestformat=json'
		json_data = JSON.load rest_data	
		empty_table = Array.new(json_data.size) { Array.new(2) }
		count = 0 
		json_data.each do |course|
			puts course['id']
			empty_table[count][0] = course['id']
			puts course['fullname']
			empty_table[count][1] = course['name']
			count +=1
		end
		return empty_table
	end

end
