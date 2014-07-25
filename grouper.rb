class Grouper
  attr_reader :groups

  def initialize(args)
    @list = args[:list]
    @max_group_size = args.fetch(:max_group_size) { 4 }
    @previous_groups = args.fetch(:previous_groups) { [] }
  end

  def group
    record_pair_history

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


    if groups.last.size == 1 || max_group_size - groups.last.size > 1
      extras = groups.pop

      extras.each do |name|
        groups_without_extras = groups.select { |group| group.size == max_group_size }
        group_for_name = groups_without_extras.min_by { |group| group & name_pairs_map[name] }
        group_for_name ? group_for_name << name : groups.first << name
      end
    end

    groups
  end

  def report_overlap
    record_of_repeat_pairs = name_pairs_map.keys.sort.each_with_object([]) do |name, memo|
      overlap = name_pairs_map[name] & groups.find { |group| group.include? name}
      memo << "#{name}:\t#{overlap.size } repeat pairs" unless overlap.empty?
    end

    record_of_repeat_pairs << "No repeat pairs" if record_of_repeat_pairs.empty?
    return record_of_repeat_pairs
  end

  def group_list
    groups_made? ? groups.map.with_index { |group, index| "#{index + 1}.  #{group.join(', ')}" } : "Groups haven't been assigned."
  end


  private
  attr_reader :list, :previous_groups, :name_pairs_map, :max_group_size

  def record_pair_history
    @name_pairs_map = shuffled_list.each_with_object({}) do |list_item, memo|
      memo[list_item] = previous_pairs(list_item)
    end
  end

  def previous_pairs(name)
    previous_groups.select { |group| group.include?(name) }.flatten.uniq.reject { |x| x == name }
  end

  def max_groups
    @max_groups ||= (list.size % max_group_size).zero? ? (list.size / max_group_size) : (list.size / max_group_size + 1)
  end

  def shuffled_list
    list.shuffle
  end

  def groups_made?
    !groups.nil?
  end
end
