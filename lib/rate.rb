module Rate

  RATING_NORMALISER = 6.0

  # Calculates the weight of a given users opinion for a work.
  # The calculation is:
  #                         
  #   W = foreach w in user ( matchedtags  *  (rating+1) )
  #                           -----------     ----------
  #                           totaltags            6
	#
	#       ------------------------------------------------
  #              foreach w in user  ( matchedtags )
	#                                 ---------------
	#                                    totaltags
	#
	# @params		rating_user			User rating the work
	# @params		work						Work being rated
	#
  # @returns									Weight of users' opinion
  def Rate.calculate_weight(rating_user, work)
    
    # for each userwork ( matchedtags/totaltags * (rating+1/6) )
    target_tags = work.tags
    total_tags = target_tags.size.to_f

    pre_averaged_total = 0.0
		pre_average_matched_tags_percent = 0.0

    # Do the beefy stuff
    rating_user.works.each do |w|
      matched_tags = (target_tags&w.tags).size.to_f
      if w.rating.nil?
        work_rating = 1
      else
        work_rating = w.rating + 1
      end

      pre_averaged_total += (matched_tags/total_tags) * (work_rating/RATING_NORMALISER)
			pre_average_matched_tags_percent += (matched_tags/total_tags)
    end

      weight = pre_averaged_total/pre_average_matched_tags_percent
      if weight.nan?
	weight = 0.0001
      end
	

      return weight
  end

	#TODO Calculates a works' rating based upon its user ratings and weights
	#
	# @params		work			Work to be rated
	def Rate.calculate_rating(work)
		
		total_w = 0.0
		total_wn = 0.0

		work.ratings.each do |r|
			total_wn += r.weight*r.score
			total_w += r.weight
		end

		score = (total_wn/total_w)

		if score.nan?
			score = 0
		end

		work.rating = score.ceil
		work.save

		return work.rating

	end

end
