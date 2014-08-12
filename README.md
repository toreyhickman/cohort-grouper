# Cohort Grouper

## Overview
This tool helps to assign students to weekly groups.  Given a list of names and a previous group history, it will attempt to group students with other students with whom they've yet to work.

Because the time it takes to compute all possible group combinations before selecting one with no repeat pairings, this program attempts to assign groups by randomizing the list of names and then placing each student into the best possible group at the time each student's name is encountered in the randomized list.

Given a Dev Bootcamp cohort name (e.g., "Mantises 2014"), this program will pull a list of students in the cohort and assign each student to a group.  The groups will then be displayed with a report of which students, if any, would have repeat pairs.  The user is given the option to use the generated grouping or to reassign the groups.  When the user commits to using a generated grouping, the groups are output to a .csv file to preserve the history of groups (e.g., `cohort-group-records/Mantises 2014.csv`).  This history is used the next time groups are generated.

## Dependencies
This program utilizes Dev Bootcamp's API for retrieving cohort and student data.  As such, users will need to have an API key—available to authorized users from [developer.devbootcamp.com](http://developer.devbootcamp.com).  The program utilizes the [dbc-ruby gem](https://rubygems.org/gems/dbc-ruby) for making requests against the API.

## Setup
- Clone this repository.
- From the command line run `bundle install`.
- Make your DBC API key available. The program will attempt to access your DBC API key as the DBC_API_KEY environment variable:

  ```ruby
  DBC::token = ENV["DBC_API_KEY"]
  ```

## Running the Program
Run this program from the command line, passing in the name of the cohort for which you want to make groups.  Optionally, you can specify a target group size; it defaults to four if not specified.

For example, if you wanted to assign the 2014 Mantises to groups, run ...

```
ruby driver.rb "Mantises 2014"
```
