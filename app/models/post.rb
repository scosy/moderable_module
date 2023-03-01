class Post < ApplicationRecord
  include Moderable

  moderable_columns(:title, :body)
end
