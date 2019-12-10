# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  title      :string
#  public     :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
    validates_presence_of :title, if: :public

    after_save :ensure_thumbnail
    after_update :ensure_thumbnail

    belongs_to :user
    has_many_attached :uploads

    # TODO: either this doesn't work, or it takes a long time to process
    def ensure_thumbnail
        puts "ensuring thumbnail for post no. #{self.id}"
        thumbnail if self.uploads.attached?
    end

    def thumbnail
        self.uploads.first.variant(resize: "240x").processed if self.uploads.first.variable?
    end
end
