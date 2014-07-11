class Grouper
  attr_reader :list, :previous_groups, :name_pairs_map, :max_group_size, :groups

  def initialize(args)
    @max_group_size = args.fetch(:max_group_size) { 4 }
    @list = args[:list]
    @previous_groups = args.fetch(:previous_groups) { [] }
    @name_pairs_map  = record_pair_history
  end

  def record_pair_history
    shuffled_list.each_with_object({}) do |list_item, memo|
      memo[list_item] = previous_pairs(list_item)
    end
  end

  def previous_pairs(name)
    previous_groups.select { |group| group.include?(name) }.flatten.uniq.reject { |x| x == name }
  end

  def group
    @groups = name_pairs_map.each_with_object(Array.new(1, [])) do |(name, previous_pairs), new_groups|
      new_groups.each do |group|
        if group.size < max_group_size && (previous_pairs & group).empty?
          group << name
          break
        end
      end

      if new_groups.none? { |group| group.include?(name) }
        new_groups.size == max_groups ? (new_groups.find { |group| group.size < max_group_size } << name) : (new_groups << [name])
      end
    end
  end

  def report_overlap(groups)
    record_of_repeat_pairs = name_pairs_map.keys.sort.each_with_object([]) do |name, memo|
      overlap = name_pairs_map[name] & groups.find { |group| group.include? name}
      memo << "#{name}:\t#{overlap.size } repeat pairs" unless overlap.empty?
    end

    record_of_repeat_pairs << "No repeat pairs" if record_of_repeat_pairs.empty?
    return record_of_repeat_pairs
  end

  # def sorted_pairs_map
  #   Hash[self.name_pairs_map.sort_by { |key, value| value.length }]
  # end

  def max_groups
    @max_groups ||= (list.size % max_group_size).zero? ? (list.size / max_group_size) : (list.size / max_group_size + 1)
  end

  def shuffled_list
    list.shuffle
  end

  def groups_made?
    !groups.nil?
  end

  def group_list
    groups_made? ? groups.map.with_index { |group, index| "#{index + 1}.  #{group.join(', ')}" } : "Groups haven't been assigned."
  end

  # def make_groups(list)
  #   list.each_slice(4).to_a
  # end

  # def all_new_groups?(proposed_groups)
  #   proposed_groups.all? { |group| new_group?(group) }
  # end

  # def new_group?(group, max_overlap = 1)
  #   self.previous_groups.all? do |previous_group|
  #     (group & previous_group).length <= max_overlap
  #   end
  # end
end
