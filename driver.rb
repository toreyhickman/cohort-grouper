require "pp"
require 'csv'
require 'pathname'
require 'dbc-ruby'

require_relative "grouper"
require_relative "dbc_patch"



if ARGV[0] && __FILE__ == $0
  DBC::token = ENV["DBC_API_KEY"]

  # Assign ARGV values to variables
  CohortName = ARGV[0]
  MaxGroupSize = ARGV[1].to_i




  cohort = DBC::Cohort.find_by_name(CohortName)
  Names = cohort.student_names


  cohort_csv_file_path = "./cohort-group-records/#{CohortName}"
  PreviousGroups = Pathname.new(cohort_csv_file_path).exist? ? CSV.read(cohort_csv_file_path) : Array.new


  def confirm_groups
    puts "Do you want to use these groups? ( y / n )"
    response = $stdin.gets.chomp.downcase
    return response =~ /y/ ? true : false
  end



  grouper = Grouper.new(list: Names, previous_groups: PreviousGroups, max_group_size: MaxGroupSize)

  groups_ok = false
  until groups_ok

    proposed_groups = grouper.group

    puts "\nStudents with repeat pairs:"
    puts grouper.report_overlap(proposed_groups)

    pp proposed_groups

    groups_ok = confirm_groups
  end
end
