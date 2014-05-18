require_relative "../grouper.rb"

describe Grouper do
    let(:list) { %w(a b c d e f) }
    let(:no_repeats) { %w(a b c d) }
    let(:repeats) { %w(e f g h) }
    let(:previous_groups) { [ %w(e f), %w(i j k l)] }
    let(:grouper) { Grouper.new(previous_groups) }

  describe "#group" do
    it "returns a nested array" do
      grouper.stub(:all_new_groups?) { true }

      expect(grouper.group(list).first).to be_an Array
    end
  end

  describe "#make_groups" do
    it "divides list into groups of four" do
      expect(grouper.make_groups(list).first).to have(4).items
    end
  end

  describe "#all_new_groups?" do
    it "detects when any group includes a repeat pair" do
      grouper.stub(:new_group?) { false }
      expect(grouper.new_group?([])).to be_false
    end

    it "detects when no groups include a repeat pair" do
      grouper.stub(:new_group?) { true }
      expect(grouper.new_group?([])).to be_true
    end
  end

  describe "#new_group?" do
    it "detects when a group includes previous pairs" do
      expect(grouper.new_group?(repeats)).to be_false
    end

    it "detects when a group includes no previous pairs" do
      expect(grouper.new_group?(no_repeats)).to be_true
    end
  end
end
