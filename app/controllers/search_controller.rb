require_dependency 'search'

class SearchController < ApplicationController

  def search
		if !params[:search_query].nil? && params[:search_query] != ""
			@query = params[:search_query]

			keywords = @query.split(" ")
			strs = []
      wstrs = []

			u_all = User.all
			w_all = Work.all
			u_all.each { |u| strs << u.search_str}
			w_all.each { |w| wstrs << w.search_str}

			results = Search.search_and_rank(keywords, strs)
			resultsw = Search.search_and_rank(keywords, wstrs)

			@results = []
			results.each { |r| @results << User.where(:search_str => r)[0]}

			@results_w = []
			resultsw.each { |r| @results_w << Work.where(:search_str => r)[0]}

		end

		@recent_users = User.all(:order => :updated_at, :limit => 5)
		@recent_works = Work.all(:order => :updated_at, :limit => 5)
  end

end
