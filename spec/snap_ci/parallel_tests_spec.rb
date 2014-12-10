require 'spec_helper'

describe SnapCI::ParallelTests do
  include SnapCI::ParallelTests

  it 'should create uniform partitions of things based on count and index' do
    things = (1..10).to_a

    partition1 = partition(things, 3, 1)
    partition2 = partition(things, 3, 2)
    partition3 = partition(things, 3, 3)

    expect(partition1).to eq([1, 2, 3, 4])
    expect(partition2).to eq([5, 6, 7, 8])
    expect(partition3).to eq([9, 10])

    expect(partition1 + partition2 + partition3).to eq(things)
  end

  it 'should create empty partitions if things are empty' do
    things = []

    partition1 = partition(things, 3, 1)
    partition2 = partition(things, 3, 2)
    partition3 = partition(things, 3, 3)

    expect(partition1).to eq(nil)
    expect(partition2).to eq(nil)
    expect(partition3).to eq(nil)
  end

  it 'should create empty partitions at end if partitions are more than number of things' do
    things = [1, 2]

    partition1 = partition(things, 3, 1)
    partition2 = partition(things, 3, 2)
    partition3 = partition(things, 3, 3)

    expect(partition1).to eq([1])
    expect(partition2).to eq([2])
    expect(partition3).to eq(nil)
  end
end
