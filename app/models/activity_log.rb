class ActivityLog < ApplicationRecord
  belongs_to :user

  # Дії користувачів
  enum action: {
    viewed_book: "viewed_book",
    added_to_cart: "added_to_cart",
    removed_from_cart: "removed_from_cart",
    searched: "searched",
    created_order: "created_order",
    commented: "commented",
    chatted: "chatted"
  }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_action, ->(action) { where(action: action) }
  scope :today, -> { where("DATE(created_at) = ?", Date.today) }
  scope :this_week, -> { where("DATE(created_at) >= ?", Date.today - 7.days) }

  # Логування дії користувача
  def self.log_action(user, action, resource_type = nil, resource_id = nil, details = {}, request = nil)
    create(
      user: user,
      action: action,
      resource_type: resource_type,
      resource_id: resource_id,
      details: details.to_json,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent
    )
  end
end
