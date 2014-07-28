require_relative "../grouper.rb"

describe Grouper do
  let(:list) { %w(a b c d e f g h i j k l) }
  let(:previous_groups) { Array.new }
  let(:grouper) { Grouper.new(list: list, previous_groups: previous_groups) }

  describe "#group" do
    it "calls for the pair history" do
      allow(grouper).to receive(:name_pairs_map) { Array.new }
      allow(grouper).to receive(:record_pair_history) { nil }

      expect(grouper).to receive(:record_pair_history)

      grouper.group
    end

    it "calls for setting the groups structure" do
      allow(grouper).to receive(:name_pairs_map) { Array.new }
      allow(grouper).to receive(:record_pair_history) { nil }

      expect(grouper).to receive(:set_groups_structure)

      grouper.group
    end

    it "fills the open slots" do
      grouper.group
      nils = grouper.groups.flatten.keep_if(&:nil?)

      expect(nils).to be_empty
    end
  end

  describe "private methods" do
    describe "#record_pair_history" do
      let(:previous_groups) { [%w(e f)] }

      it "returns each item in list mapped to its previous pairs" do
        expect(grouper.send(:record_pair_history)['e']).to eq %w(f)
        expect(grouper.send(:record_pair_history)['a']).to eq %w()
      end
    end

    describe "#previous_pairs" do
      let(:previous_groups) { [%w(e f)] }

      it "finds the previous pairs for an item" do
        expect(grouper.send(:previous_pairs, "e")).to eq %w(f)
      end
    end

    describe "#max_groups" do
      context "list size evenly divisible by max group size" do
        it "divides list size by max group size" do
          allow(grouper).to receive(:list) { Array.new(16) }
          allow(grouper).to receive(:max_group_size) { 4 }

          expect(grouper.send(:max_groups)).to eq 4
        end
      end

      context "list size not evenly divisible by max group size" do
        it "divides list size by max group size and adds one" do
          allow(grouper).to receive(:list) { Array.new(18) }
          allow(grouper).to receive(:max_group_size) { 4 }

          expect(grouper.send(:max_groups)).to eq 5
        end
      end
    end

    describe "#set_groups_structure" do
      context "list size evenly divisible by max group size" do
        it "creates the right number of groups" do
          allow(grouper).to receive(:list) { Array.new(16) }
          allow(grouper).to receive(:max_group_size) { 4 }

          expect(grouper.send(:set_groups_structure).size).to eq 4
        end

        it "puts the correct number of slots in each group" do
          allow(grouper).to receive(:list) { Array.new(16) }
          allow(grouper).to receive(:max_group_size) { 4 }

          expect(grouper.send(:set_groups_structure).map(&:size)). to eq [4, 4, 4, 4]
        end
      end

      context "list size not evenly divisible by max group size" do
        it "creates the right number of groups" do
          allow(grouper).to receive(:list) { Array.new(18) }
          allow(grouper).to receive(:max_group_size) { 4 }

          expect(grouper.send(:set_groups_structure).size).to eq 4
        end

        it "puts the correct number of slots in each group" do
          allow(grouper).to receive(:list) { Array.new(18) }
          allow(grouper).to receive(:max_group_size) { 4 }

          expect(grouper.send(:set_groups_structure).map(&:size)). to eq [5, 5, 4, 4]
        end
      end
    end
  end
end
