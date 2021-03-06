# frozen_string_literal: true

# == Schema Information
#
# Table name: weekly_selections
#
#  id              :bigint           not null, primary key
#  bookmarks_count :integer          default(0), not null
#  description     :text
#  is_published    :boolean          default(FALSE), not null
#  issue_no        :bigint
#  lang            :integer          default("english"), not null
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class WeeklySelection < ApplicationRecord
  BOOKMARKS_COUNT = 5
  has_many :bookmarks, lambda { excellented_order }
  validates :title, :bookmarks_count, presence: true

  enum lang: {
    english: 0,
    chinese: 1,
    all_lang: 2,
  }

  def full_title
    "#{title} | #{I18n.t("issue_no", no: issue_no)}"
  end
end
