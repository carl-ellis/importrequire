require_dependency 'search'

class SearchController < ApplicationController

  def search
		if !params[:search_query].nil? && params[:search_query] != ""
			@query = params[:search_query]

			keywords = @query.split(" ")
			strs = []

			u_all = User.all
			u_all.each { |u| strs << u.search_str}

			results = Search.search_and_rank(keywords, strs)

			@results = []
			results.each { |r| @results << User.where(:search_str => r)[0]}

		end

		@recent_users = User.all(:order => :updated_at, :limit => 5)
  end

end
