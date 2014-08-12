class Grouper
  attr_reader :groups

  def initialize(args)
    @list = args[:list]
    @target_group_size = args.fetch(:target_group_size) { 4 }
    @previous_groups = args.fetch(:previous_groups) { [] }
  end

  def group
    record_pair_history
    set_groups_structure

    name_pairs_map.each do |name, previous_pairs|
      place_in_group(name, previous_pairs)
    end

    groups
  end

  def report_overlap
    record_of_repeat_pairs = list.each_with_object(Array.new) do |name, overlap_records|
      overlap = repeat_pairs(name)
      overlap_records << "#{name}:\t#{overlap.size } repeat pairs" unless overlap.empty?
    end

    record_of_repeat_pairs << "No repeat pairs" if record_of_repeat_pairs.empty?
    return record_of_repeat_pairs
  end

  def group_list
    groups_made? ? stringify_groups : "Groups haven't been assigned."
  end


  private
  attr_reader :list, :previous_groups, :name_pairs_map, :target_group_size

  def record_pair_history
    @name_pairs_map = shuffled_list.each_with_object(Hash.new) do |name, name_pairs|
      name_pairs[name] = previous_pairs(name)
    end
  end

  def set_groups_structure
    @groups = Array.new(target_groups) { Array.new(target_group_size, nil) }
    correct_for_uneven_groups
    disband_small_final_group

    groups
  end

  def correct_for_uneven_groups
    unless even_groups?
      groups.pop
      groups << Array.new(uneven_group_count, nil)
    end
  end

  def disband_small_final_group
    if last_group_too_small
      groups.pop.each_with_index { |name, index| groups[index] << name }
    end
  end

  def last_group_too_small
    last_group_size = groups.last.size

    last_group_size == 1 || (target_group_size - last_group_size) > 1
  end

  def previous_pairs(name)
    previous_groups_of(name).flatten.uniq.reject { |x| x == name }
  end

  def previous_groups_of(name)
    previous_groups.select { |group| group.include?(name) }
  end

  def target_groups
    @target_groups ||= calculate_target_groups
  end

  def calculate_target_groups
    even_groups? ? full_groups_count : full_groups_count + 1
  end

  def even_groups?
    uneven_group_count.zero?
  end

  def uneven_group_count
    (list.size % target_group_size)
  end

  def full_groups_count
    list.size / target_group_size
  end

  def shuffled_list
    list.shuffle
  end

  def groups_made?
    !(groups.nil?)
  end

  def stringify_groups
    groups.map.with_index { |group, index| "#{index + 1}.  #{group.join(', ')}" }
  end

  def group_of(name)
    groups.find { |group| group.include? name }
  end

  def repeat_pairs(name)
    name_pairs_map[name] & group_of(name)
  end

  def open_groups
    groups.select { |group| group.include? nil }
  end

  def best_group_based_on(previous_pairs)
    open_groups.min_by { |group| (group & previous_pairs).size }
  end

  def place_in_group(name, previous_pairs)
    best_group = best_group_based_on(previous_pairs)
    index_of_nil = best_group.index(nil)

    best_group[index_of_nil] = name
  end
end
