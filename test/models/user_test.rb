# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  about                     :text
#  admin                     :boolean          default(FALSE)
#  bookmarks_count           :integer          default(0)
#  comments_count            :integer          default(0)
#  default_bookmark_lang     :integer          default("all_lang"), not null
#  email                     :string
#  enable_email_notification :boolean          default(TRUE)
#  extension_token           :string
#  follow_tags_count         :integer          default(0)
#  followers_count           :integer          default(0)
#  followings_count          :integer          default(0)
#  homepage                  :string
#  lang                      :integer          default("english"), not null
#  password_digest           :string
#  remember_token            :string
#  score                     :integer
#  taggings_count            :integer          default(0)
#  tags_count                :integer          default(0)
#  username                  :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_users_on_email               (email) UNIQUE
#  index_users_on_email_lower_unique  (lower((email)::text)) UNIQUE
#  index_users_on_remember_token      (remember_token) UNIQUE
#  index_users_on_score               (score)
#  index_users_on_updated_at          (updated_at)
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
