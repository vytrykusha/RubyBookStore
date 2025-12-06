class EditablePage < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true
end
