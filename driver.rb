require_relative "grouper"
require "pp"
require 'csv'
require 'dbc-ruby'

Names = [
    "Andrew",
    "Anne",
    "Ariel",
    "Ben",
    "Caroline",
    "Casey",
    "Daniel",
    "Dusty",
    "Beth",
    "Erik",
    "Fabi",
    "Gustavo",
    "Jaimin",
    "Jared",
    "Justin",
    "Michael",
    "Mohammad",
    "Nate",
    "Oliver",
    "Paige",
    "Parth",
    "Raza",
    "Robb",
    "Sammy",
    "Sasha",
    "Tom N."
  ]

  PreviousGroups = [
    %w(Casey Gustavo Anne Nate),
    %w(Daniel Tom\ N. Fabi Tom\ H.),
    %w(Sasha Ariel Erik Jaimin),
    %w(Sammy Justin Andrew Liz),
    %w(Mohammad Milan Jared Parth),
    %w(Dusty Michael Oliver Paige),
    %w(Ben Beth Caroline Robb),
  ]


grouper = Grouper.new(list: Names, previous_groups: PreviousGroups)

proposed_groups = grouper.group

puts grouper.report_overlap(proposed_groups)

pp proposed_groups
