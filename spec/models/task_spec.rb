require 'rails_helper'

RSpec.describe Task, type: :model do

  context "validating attributes" do
    it 'checking valid attributes' do
      task = build(:task )
      expect(task).to be_valid
    end

    it 'checking if title is nil' do
      task = build(:task, title: nil )
      expect(task).not_to be_valid
    end
  end

  describe "Description" do
    context "when description is present" do 
      it 'returns true when save task' do
        task = build(:task, description: "abc")
        expect(task.save).to eq(true)
      end
    end
  
    context "when description is not present" do 
      it 'returns false when save task' do
        task = build(:task, description: nil)
        expect(task.save).to eq(false)
      end
  
      it 'returns an error message' do
        task = build(:task, description: nil)
        task.save
        expect(task.errors.messages[:description]).to include("can't be blank")
      end
    end
  end

  describe "Status" do
    context "when status is present" do 
      it 'returns true when save task' do
        task = build(:task, status: 1)
        expect(task.save).to eq(true)
      end

      it 'returns false when save task invalid' do
        task = build(:task, status: 9)
        expect(task.save).to eq(false)
      end  
    end
  
    context "when status is not present" do 
      it 'returns false when save task' do
        task = build(:task, status: nil)
        expect(task.save).to eq(false)
      end

      it 'returns an error message' do
        task = build(:task, status: nil)
        task.save
        expect(task.errors.messages[:status]).to include("can't be blank")
      end
    end
  end
  

  describe "user" do
    context "when user is present" do 
      it 'returns true when save task' do
        user = build(:user)
        task = create(:task, user: user )
        expect(task.save).to eq(true)
      end
    end
  
    context "when user is not present" do 
      it 'returns false when save task' do
        task = build(:task, user: nil)
        expect(task.save).to eq(false)
      end
  
      it 'returns an error message' do
        task = build(:task, user: nil)
        task.save
        expect(task.errors.messages[:user]).to include("can't be blank")
      end
    end
  end
end
