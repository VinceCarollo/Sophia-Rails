class List < ApplicationRecord
  belongs_to :client
  belongs_to :caretaker, optional: true
  has_many :tasks, dependent: :destroy

  validates_presence_of :name

  validates :created_for, inclusion: { in: ['client', 'caretaker'] }

  enum created_for: [:client, :caretaker]
end
