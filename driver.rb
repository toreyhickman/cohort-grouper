require_relative "grouper"
require "pp"

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
    "Liz",
    "Erik",
    "Fabi",
    "Gustavo",
    "Jaimin",
    "Jared",
    "Justin",
    "Michael",
    "Milan",
    "Mohammad",
    "Nate",
    "Oliver",
    "Paige",
    "Parth",
    "Robb",
    "Sammy",
    "Sasha",
    "Tom H.",
    "Tom N."
  ]

  PreviousGroups = [
    %w(Anne Daniel Jared Parth),
    %w(Ariel Dusty Sammy Tom\ N.),
    %w(Ben Liz Milan Sasha),
    %w(Caroline Gustavo Monica Steve),
    %w(Casey Jaimin Tom\ H.),
    %w(Anne Ariel Ben Caroline),
    %w(Casey Daniel Dusty Liz),
    %w(Gustavo Jaimin Jared Sammy),
    %w(Sasha Monica Tom\ H. Parth),
    %w(Tom\ N. Milan Steve),
    %w(Anne Monica Dusty Tom\ N.),
    %w(Ben Milan Caroline Ariel),
    %w(Liz Jaimin Tom\ H. Jared),
    %w(Daniel Sasha Casey Steve),
    %w(Gustavo Sammy Parth),
    %w(Paige Justin),
    %w(Mohammad Beth Michael),
    %w(Andrew Paige),
    %w(Erik Beth),
    %w(Nate Michael),
    %w(Oliver Fabi),
    %w(Erik Oliver Justin Nate Mohammad),
    %w(Michael Beth),
    %w(Fabi Andrew),
    %w(Casey Gustavo Anne Nate),
    %w(Daniel Tom\ N. Fabi Tom\ H.),
    %w(Sasha Ariel Erik Jaimin),
    %w(Sammy Justin Andrew Liz),
    %w(Mohammad Milan Jared Parth),
    %w(Dusty Michael Oliver Paige),
    %w(Ben Beth Caroline Robb)
  ]

grouper = Grouper.new(PreviousGroups)

pp grouper.group(Names)
