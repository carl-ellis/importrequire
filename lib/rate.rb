module Rate

  RATING_NORMALISER = 6.0

  # Calculates the weight of a given users opinion for a work.
  # The calculation is:
  #                         ^
  #   W = foreach w in user ( matchedtags  *  (rating+1) )
  #                           -----------     ----------
  #                           totaltags            6
  def Rate.calculate_weight(rating_user, work)
    
    # for each userwork ( matchedtags/totaltags * (rating+1/6) )
    target_tags = work.tags
    total_tags = target_tags.size.to_f

    pre_averaged_total = 0.0

    # Do the beefy stuff
    rating_user.works.each do |w|
      matched_tags = (target_tags&w.tags).size.to_f
      if w.rating.nil?
        work_rating = 1
      else
        work_rating = w.rating + 1
      end

      pre_averaged_total += (matched_tags/total_tags) * (work_rating/RATING_NORMALISER)
    end

      weight = pre_averaged_total/rating_user.works.size

      return weight

  end

end
