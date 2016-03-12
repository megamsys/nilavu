##
## Copyright [2013-2016] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##

class CockpitsController < ApplicationController
  include CatalogHelper

  respond_to :html, :js

  before_action :add_authkeys_for_api, only: [:index]

  def index
    @assemblies_grouped = Api::Assemblies.new.list(params).assemblies_grouped
  end

  def show
    redirect_to(cockpits_path) && return
  end

=begin


  before_filter :ensure_logged_in, except: [
    :topics_by,
    # anonymous filters
    Nilavu.anonymous_filters,
    Nilavu.anonymous_filters.map { |f| "#{f}_feed" },
    # anonymous categorized filters
    Nilavu.anonymous_filters.map { |f| :"category_#{f}" },
    Nilavu.anonymous_filters.map { |f| :"category_none_#{f}" },
    Nilavu.anonymous_filters.map { |f| :"parent_category_category_#{f}" },
    Nilavu.anonymous_filters.map { |f| :"parent_category_category_none_#{f}" },
    # category feeds
    :category_feed,
    # top summaries
    :top,
    :category_top,
    :category_none_top,
    :parent_category_category_top,
    # top pages (ie. with a period)
    TopTopic.periods.map { |p| :"top_#{p}" },
    TopTopic.periods.map { |p| :"category_top_#{p}" },
    TopTopic.periods.map { |p| :"category_none_top_#{p}" },
    TopTopic.periods.map { |p| :"parent_category_category_top_#{p}" },
  ].flatten

  # Create our filters
  Nilavu.filters.each do |filter|
    define_method(filter) do |options = nil|
      list_opts = build_topic_list_options
      list_opts.merge!(options) if options
      user = list_target_user

      if params[:category].blank?
        if filter == :latest
          list_opts[:no_definitions] = true
        end
        if filter.to_s == current_homepage
          list_opts[:exclude_category_ids] = get_excluded_category_ids(list_opts[:category])
        end
      end

      list = TopicQuery.new(user, list_opts).public_send("list_#{filter}")

      list.more_topics_url = construct_url_with(:next, list_opts)
      list.prev_topics_url = construct_url_with(:prev, list_opts)
      if Nilavu.anonymous_filters.include?(filter)
        @description = SiteSetting.site_description
        @rss = filter

        # Note the first is the default and we don't add a title
        if (filter.to_s != current_homepage) && use_crawler_layout?
          filter_title = I18n.t("js.filters.#{filter.to_s}.title", count: 0)
          if list_opts[:category]
            @title = I18n.t('js.filters.with_category', filter: filter_title, category: Category.find(list_opts[:category]).name)
          else
            @title = I18n.t('js.filters.with_topics', filter: filter_title)
          end
        end
      end

      respond_with_list(list)
    end

    define_method("category_#{filter}") do
      canonical_url "#{Nilavu.base_url_no_prefix}#{@category.url}"
      self.send(filter, category: @category.id)
    end

    define_method("category_none_#{filter}") do
      self.send(filter, category: @category.id, no_subcategories: true)
    end

    define_method("parent_category_category_#{filter}") do
      canonical_url "#{Nilavu.base_url_no_prefix}#{@category.url}"
      self.send(filter, category: @category.id)
    end

    define_method("parent_category_category_none_#{filter}") do
      self.send(filter, category: @category.id)
    end
  end
=end
end
