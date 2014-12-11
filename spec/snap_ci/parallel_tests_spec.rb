require 'spec_helper'

describe SnapCI::ParallelTests do
  include SnapCI::ParallelTests

  describe 'default (round robin) distribution behavior, when distribution option is not passed' do

    it 'should create uniform partitions of things based on count and index' do
      things = (1..10).to_a

      partition1 = partition(things: things, total_workers: 3, current_worker_index: 1)
      partition2 = partition(things: things, total_workers: 3, current_worker_index: 2)
      partition3 = partition(things: things, total_workers: 3, current_worker_index: 3)

      expect(partition1 + partition2 + partition3).to contain_exactly(*things)

      expect(partition1).to eq([1, 4, 7, 10])
      expect(partition2).to eq([2, 5, 8])
      expect(partition3).to eq([3, 6, 9])
    end

    it 'should create empty partitions if things are empty' do
      things = []

      partition1 = partition(things: things, total_workers: 3, current_worker_index: 1)
      partition2 = partition(things: things, total_workers: 3, current_worker_index: 2)
      partition3 = partition(things: things, total_workers: 3, current_worker_index: 3)

      expect(partition1).to eq([])
      expect(partition2).to eq([])
      expect(partition3).to eq([])
    end

    it 'should create empty partitions at end if partitions are more than number of things' do
      things = [1, 2]

      partition1 = partition(things: things, total_workers: 3, current_worker_index: 1)
      partition2 = partition(things: things, total_workers: 3, current_worker_index: 2)
      partition3 = partition(things: things, total_workers: 3, current_worker_index: 3)

      expect(partition1).to eq([1])
      expect(partition2).to eq([2])
      expect(partition3).to eq([])
    end

  end

  describe 'round robin distribution, when distribution option is not passed' do
    it 'should create uniform partitions of things based on count and index' do
      things = (1..10).to_a

      partition1 = partition(things: things, total_workers: 3, current_worker_index: 1, distribution: :round_robin)
      partition2 = partition(things: things, total_workers: 3, current_worker_index: 2, distribution: :round_robin)
      partition3 = partition(things: things, total_workers: 3, current_worker_index: 3, distribution: :round_robin)

      expect(partition1 + partition2 + partition3).to contain_exactly(*things)

      expect(partition1).to eq([1, 4, 7, 10])
      expect(partition2).to eq([2, 5, 8])
      expect(partition3).to eq([3, 6, 9])
    end
  end

  describe 'chunk distribution' do

    it 'should create uniform partitions of things based on count and index' do
      things = (1..10).to_a

      partition1 = partition(things: things, total_workers: 3, current_worker_index: 1, distribution: :chunk)
      partition2 = partition(things: things, total_workers: 3, current_worker_index: 2, distribution: :chunk)
      partition3 = partition(things: things, total_workers: 3, current_worker_index: 3, distribution: :chunk)

      expect(partition1 + partition2 + partition3).to contain_exactly(*things)

      expect(partition1).to eq([1, 2, 3, 4])
      expect(partition2).to eq([5, 6, 7, 8])
      expect(partition3).to eq([9, 10])
    end

    it 'should create empty partitions if things are empty' do
      things = []

      partition1 = partition(things: things, total_workers: 3, current_worker_index: 1, distribution: :chunk)
      partition2 = partition(things: things, total_workers: 3, current_worker_index: 2, distribution: :chunk)
      partition3 = partition(things: things, total_workers: 3, current_worker_index: 3, distribution: :chunk)

      expect(partition1).to eq([])
      expect(partition2).to eq([])
      expect(partition3).to eq([])
    end

    it 'should create empty partitions at end if partitions are more than number of things' do
      things = [1, 2]

      partition1 = partition(things: things, total_workers: 3, current_worker_index: 1, distribution: :chunk)
      partition2 = partition(things: things, total_workers: 3, current_worker_index: 2, distribution: :chunk)
      partition3 = partition(things: things, total_workers: 3, current_worker_index: 3, distribution: :chunk)

      expect(partition1).to eq([1])
      expect(partition2).to eq([2])
      expect(partition3).to eq([])
    end

  end

end
