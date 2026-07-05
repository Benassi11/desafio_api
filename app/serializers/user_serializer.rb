# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :nickname, :is_admin

  has_many :tasks
end
