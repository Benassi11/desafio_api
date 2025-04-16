require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "validating attributes" do
    it 'checking valid attributes comment' do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it 'checking valid attributes comment_parent' do
      comment = build(:comment, :comment_parent)
      expect(comment).to be_valid
    end
  end

  describe "Description" do
    context "when description is present" do
      it 'returns true when save comment' do
        comment = build(:comment, description: "abc")
        expect(comment.save).to eq(true)
      end
    end

    context "when description is not present" do
      it 'returns false when save comment' do
        comment = build(:comment, description: nil)
        expect(comment.save).to eq(false)
      end

      it 'returns an error message' do
        comment = build(:comment, description: nil)
        comment.save
        expect(comment.errors.messages[:description]).to include("can't be blank")
      end
    end
  end

  describe "User" do
    context "when user is present" do
      it 'returns true when save user' do
        user = create(:user)
        comment = build(:comment, user: user)
        expect(comment.save).to eq(true)
      end
    end

    context "when user is not present" do
      it 'returns false when save comment' do
        comment = build(:comment, user: nil)
        expect(comment.save).to eq(false)
      end

      it 'returns an error message' do
        comment = build(:comment, user: nil)
        comment.save
        expect(comment.errors.messages[:user]).to include("can't be blank")
      end
    end
  end

  describe "task" do
    context "when task is present" do
      it 'returns true when save comment' do
        task = create(:task)
        comment = build(:comment, task: task)
        expect(comment.save).to eq(true)
      end
    end

    context "when task is not present" do
      it 'returns false when save comment' do
        comment = build(:comment, task: nil)
        expect(comment.save).to eq(false)
      end

      it 'returns an error message' do
        comment = build(:comment, task: nil)
        comment.save
        expect(comment.errors.messages[:task]).to include("can't be blank")
      end
    end
  end

  describe "parent comment" do
    context "when parent is present" do
      it 'returns true when save comment' do
        parent_comment = create(:comment)
        comment = build(:comment, parent: parent_comment)
        expect(comment.save).to eq(true)
      end
    end

    context "when parent is not present" do
      it 'returns true when save comment without parent' do
        comment = build(:comment, parent: nil)
        expect(comment.save).to eq(true)
      end
    end
  end

  describe "replies comment" do
    context "when replies are present" do
      it 'returns true when save comment' do
        reply1 = create(:comment)
        reply2 = create(:comment)
        comment = build(:comment, replies: [ reply1, reply2 ])
        expect(comment.save).to eq(true)
      end
    end

    context "when replies is not present" do
      it 'returns true when save comment without replies' do
        comment = build(:comment, replies: [])
        expect(comment.save).to eq(true)
      end
    end
  end
end
