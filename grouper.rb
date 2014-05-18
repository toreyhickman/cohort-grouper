require 'debugger'

class Grouper
  attr_reader :previous_groups

  def initialize(previous_groups = [])
    @previous_groups = previous_groups
  end

  def group(list)
    i = 1
    puts "#{i}\t\tMaking groups ..."
    proposed_groups = make_groups(shuffled(list))

    until all_new_groups?(proposed_groups)
      puts "#{i}\t\t#{proposed_groups.inspect}\n\n"

      proposed_groups = make_groups(shuffled(list))

      i += 1
    end

    proposed_groups
  end

  def shuffled(list)
    list.shuffle
  end

  def make_groups(list)
    list.each_slice(4).to_a
  end

  def all_new_groups?(proposed_groups)
    proposed_groups.all? { |group| new_group?(group) }
  end

  def new_group?(group, max_overlap = 1)
    self.previous_groups.all? do |previous_group|
      (group & previous_group).length <= max_overlap
    end
  end
end
