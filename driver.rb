require "pp"
require 'csv'
require 'dbc-ruby'

require_relative "grouper"
require_relative "dbc_patch"




DBC::token = ENV["DBC_API_KEY"]

# Assign ARGV values to variables
CohortName = ARGV[0]




cohort = DBC::Cohort.find_by_name(CohortName)
Names = cohort.student_names

PreviousGroups = [
  %w(Casey Gustavo Anne Nate),
  %w(Daniel Tom\ N. Fabi Tom\ H.),
  %w(Sasha Ariel Erik Jaimin),
  %w(Sammy Justin Andrew Liz),
  %w(Mohammad Milan Jared Parth),
  %w(Dusty Michael Oliver Paige),
  %w(Ben Beth Caroline Robb)
]


if ARGV[0] && __FILE__ == $0
  grouper = Grouper.new(list: Names, previous_groups: PreviousGroups)

  proposed_groups = grouper.group

  puts grouper.report_overlap(proposed_groups)

  pp proposed_groups
end
