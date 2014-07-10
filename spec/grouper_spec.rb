require_relative "../grouper.rb"

describe Grouper do
  let(:list) { %w(a b c d e f) }
  let(:no_repeats) { %w(a b c d) }
  let(:repeats) { %w(e f g h) }
  let(:previous_groups) { [ %w(e f), %w(i j k l)] }
  let(:grouper) { Grouper.new(list: list, previous_groups: previous_groups) }

  describe "#initialize" do
    it "calls for the pair history" do
      Grouper.any_instance.stub(:record_pair_history)
      Grouper.any_instance.should_receive(:record_pair_history)
      Grouper.new({})
    end
  end

  describe "#record_pair_history" do
    it "returns each item in list mapped to its previous pairs" do
      expect(grouper.record_pair_history['e']).to eq %w(f)
      expect(grouper.record_pair_history['a']).to eq %w()
    end
  end

  describe "#previous_pairs" do
    it "finds the previous pairs for an item" do
      expect(grouper.previous_pairs("e")).to eq %w(f)
    end
  end

  describe "#group" do
    let(:list) { %w(a b c d) }
    it "returns groups with no repeat pairs when possible" do
      grouper.stub(:name_pairs_map) { { :a => [:b],
                                        :b => [:a],
                                        :c => [:d],
                                        :d => [:c] } }
      grouper.stub(max_group_size: 3)

      expect(grouper.group).to eq [[:a, :c], [:b, :d]]
    end

    it "has a max group size" do
      grouper.stub(max_group_size: 3)
      grouper.stub(:sorted_pairs_map) { { :a => [],
                                          :b => [],
                                          :c => [],
                                          :d => [],
                                          :e => [] } }

      expect(grouper.group.first.size).to eq 3
    end
  end
end
