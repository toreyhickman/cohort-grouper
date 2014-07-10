module DBC
  class Cohort
    def self.find_by_name(name)
      cohort = self.all.find { |cohort| cohort.name == name }
    end

    def student_names
      remove_staff_from_students.map(&:name)
    end

    def remove_staff_from_students
      students.reject { |student| !((student.roles - ["student"]).empty?) }
    end
  end
end
