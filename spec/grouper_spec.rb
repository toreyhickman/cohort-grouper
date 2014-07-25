require_relative "../grouper.rb"

describe Grouper do
  let(:list) { %w(a b c d e f) }
  let(:no_repeats) { %w(a b c d) }
  let(:repeats) { %w(e f g h) }
  let(:previous_groups) { [ %w(e f), %w(i j k l)] }
  let(:grouper) { Grouper.new(list: list, previous_groups: previous_groups) }

  describe "#record_pair_history" do
    it "returns each item in list mapped to its previous pairs" do
      expect(grouper.send(:record_pair_history)['e']).to eq %w(f)
      expect(grouper.send(:record_pair_history)['a']).to eq %w()
    end
  end

  describe "#previous_pairs" do
    it "finds the previous pairs for an item" do
      expect(grouper.send(:previous_pairs, "e")).to eq %w(f)
    end
  end

  describe "#group" do
    let(:list) { %w(a b c d) }

    it "calls for the pair history" do
      allow(grouper).to receive(:name_pairs_map) { Array.new }
      allow(grouper).to receive(:record_pair_history) { nil }

      expect(grouper).to receive(:record_pair_history)

      grouper.group
    end

    it "tries to make groups with no repeat pairs" do
      allow(grouper).to receive(:name_pairs_map) { { :a => [:b],
                                                     :b => [:a],
                                                     :c => [:d],
                                                     :d => [:c] } }
      allow(grouper).to receive(:max_group_size) { 2 }

      expect(grouper.group).to eq [[:a, :c], [:b, :d]]
    end

    it "groups according to max group size" do
      allow(grouper).to receive(:max_group_size) { 3 }
      allow(grouper).to receive(:name_pairs_map) { { :a => [],
                                                     :b => [],
                                                     :c => [],
                                                     :d => [],
                                                     :e => [],
                                                     :f => [] } }

      group_sizes = grouper.group.map(&:size)
      expect(group_sizes.all? { |size| size == 3 }).to be true
    end

    it "adds extras if the size of the last group is two or more less than max group size" do
      long_list = %w(a b c d e f g h i j)
      grouper = Grouper.new(list: long_list, previous_groups: previous_groups)

      allow(grouper).to receive(:max_group_size) { 4 }
      allow(grouper).to receive(:name_pairs_map) { { :a => [],
                                                     :b => [],
                                                     :c => [],
                                                     :d => [],
                                                     :e => [],
                                                     :f => [],
                                                     :g => [],
                                                     :h => [],
                                                     :i => [],
                                                     :j => [] } }

      group_sizes = grouper.group.map(&:size)
      expect(group_sizes).to eq [5, 5]
    end

    it "keeps last group if size is one less than max group size" do
      long_list = %w(a b c d e f g h)
      grouper = Grouper.new(list: long_list, previous_groups: previous_groups)

      allow(grouper).to receive(:max_group_size) { 3 }
      allow(grouper).to receive(:name_pairs_map) { { :a => [],
                                        :b => [],
                                        :c => [],
                                        :d => [],
                                        :e => [],
                                        :f => [],
                                        :g => [],
                                        :h => [] } }

      group_sizes = grouper.group.map(&:size)
      expect(group_sizes).to eq [3, 3, 2]
    end

    it "adds extras if last group size is one" do
      five_item_list = %w(a b c d e)
      grouper = Grouper.new(list: five_item_list, previous_groups: previous_groups)

      allow(grouper).to receive(:max_group_size) { 2 }
      allow(grouper).to receive(:name_pairs_map) { { :a => [],
                                        :b => [],
                                        :c => [],
                                        :d => [],
                                        :e => [] } }

      group_sizes = grouper.group.map(&:size)
      expect(group_sizes).to eq [3, 2]

    end
  end
end
