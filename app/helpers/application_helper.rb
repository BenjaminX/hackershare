# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def title(text)
    content_for :title, text
  end

  def default_image_url
    keyword = %w[food drink nature girl film tech cat].sample
    "https://source.unsplash.com/random/507x265?#{keyword}=#{Random.hex(4)}"
  end

  def disable_with_spinner(text)
    spinner = <<~SPINNER
      <svg class="animate-spin mr-1 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    SPINNER
    [spinner, text].join.html_safe
  end

  def render_follow_text(user)
    text = user.followed_by?(current_user) ? t("unfollow") : t("follow")
    text.html_safe
  end

  def auth_provider_url(provider = :github)
    if params["chrome-callback"].present?
      "/auth/#{provider}?chrome-callback=#{params['chrome-callback']}"
    else
      "/auth/#{provider}"
    end
  end

  def render_twitter_share_link(bookmark)
    base = "https://twitter.com/intent/tweet?text="
    base += CGI.escape([
        bookmark.title.to_s,
        bookmark.tags.map { |x| "##{x.name}" }.join(" "),
        bookmark_url(bookmark)
      ].join(" ")
    )
    base
  end

  def render_telegram_share_link(bookmark)
    "https://t.me/share/url?text=#{CGI.escape bookmark.title.to_s}&url=#{CGI.escape bookmark_url(bookmark)}"
  end

  def link_to_active(text, url, options = {})
    route = Rails.application.routes.recognize_path(url)
    if options[:class]
      if controller_name == route[:controller] || (route[:controller] == "bookmarks" && controller_name == "home")
        options[:class] = options[:class] << " bg-gray-900"
      else
        options[:class] = options[:class] << " hover:bg-gray-700"
      end
    end
    link_to text, url, options
  end

  def sortby_link_to_active(text, url, current = :smart, options = {})
    if options[:class]
      if (params[:sortby].to_s == current.to_s) || (params[:sortby].blank? && current.to_s == "smart")
        options[:class] = options[:class] << " bg-gray-200"
      end
    end
    link_to text, url, options
  end

  def sortby
    valid_sortbys.include?(params[:sortby]) ? params[:sortby] : "smart"
  end

  def valid_sortbys
    %w[daily weekly monthly smart all]
  end

  def hacker_link_to_active(text, url, current = :created, options = {})
    if options[:class]
      if (params[:type].to_s == current.to_s) || (params[:type].blank? && current.to_s == "created")
        options[:class] = options[:class] << " bg-gray-200"
      end
    end
    link_to text, url, options
  end

  def ga_tracking_id
    ENV["GA_TRACKING_ID"] || "G-PJBVFLBFSB"
  end

  def tag_url_for(tag)
    if controller_name == "users"
      link_to bookmarks_path(request.query_parameters.except(:page).merge(tag: tag.name, only_path: true)), class: "btn-tag mr-1 lg:mr-2 mb-1", data: { remote: true, action: "ajax:success->listing#replace" } do
        concat "##{tag.name}"
        concat render_rss_icon(tag)
      end
    else
      link_to bookmarks_path(request.query_parameters.except(:page).merge(tag: tag.name)), class: "btn-tag mr-1 lg:mr-2 mb-1" do
        concat "##{tag.name}"
        concat render_rss_icon(tag)
      end
    end
  end

  if Rails.env.development?
    def t(*args, **options, &block)
      super(*args, **options.merge(raise: true), &block)
    end
  end

  def render_rss_icon(tag)
    icon = <<~ICON
      <svg class="h-4 w-4 text-indigo-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 5c7.18 0 13 5.82 13 13M6 11a7 7 0 017 7m-6 0a1 1 0 11-2 0 1 1 0 012 0z" />
      </svg>
    ICON
    icon.html_safe if tag.is_rss?
  end

  def feedback_link
    if I18n.locale == :'zh-CN'
      "https://cdn.hackershare.cn/wechat-hackershare.jpeg"
    else
      "https://github.com/hackershare/hackershare/issues/new"
    end
  end

  def pretty_weekly_selection_path(weekly_selection)
    case weekly_selection.lang
    when "english"
      custom_weekly_selection_path(lang: "en", issue_no: weekly_selection.issue_no)
    when "chinese"
      custom_weekly_selection_path(lang: "cn", issue_no: weekly_selection.issue_no)
    when "all_lang"
      weekly_selection_path(weekly_selection)
    end
  end
end
