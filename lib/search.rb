require 'uri'

module Search
  
  HANDLE_WEIGHT = 1.00
  AFFILIATION_WEIGHT = 0.50
  USER_TAG_WEIGHT = 0.10
  ARTICLE_TAG_WEIGHT = 0.25
  ARTICLE_NAME_WEIGHT = 0.10

  PARTIAL_MATCH_WEIGHT = 0.25

  WEIGHT_DELIM = '#'
  TAG_DELIM = ';'

  # Builds a search string in the form of tag#weight;tag#weight.
  # For users
  #
  # @params  user         The User Object
  #
  # @returns              Search String
  def Search.buildUserSearchString(user)

    str_hash = {}
    
    # crawl data
    str_hash[user.handle] = Search::HANDLE_WEIGHT
    user.tags.each do |tag|
      str_hash[tag.name] = Search::USER_TAG_WEIGHT
    end
    user.affiliations.each do |affil|
      str_hash[affil.name] = Search::AFFILIATION_WEIGHT
    end
    user.works.each do |work|
      work.name.split(" ").each do |n|
        if str_hash.keys.include?(n)
          str_hash[n] *= 2
        else
          str_hash[n] = Search::ARTICLE_NAME_WEIGHT
        end
      end
      work.tags.each do |tag|
        if str_hash.keys.include?(tag.name)
          str_hash[tag.name] *= 2
        else
          str_hash[tag.name] = Search::ARTICLE_TAG_WEIGHT
        end
      end
    end

    # build string
    search_str = ""
    str_hash.each do |k,v|
      search_str << "#{URI.escape(k)}#{Search::WEIGHT_DELIM}#{URI.escape(v.to_s)}#{Search::TAG_DELIM}"
    end
    search_str = search_str.slice(0, search_str.length-1)

    # finish up
    user.search_str = search_str
    user.save
    return search_str
    
  end
  
  #TODO Builds a search string in the form of tag#weight;tag#weight.
  # For works
  #
  # @params  work         The Work Object
  #
  # @returns              Search String
  def Search.buildWorkSearchString(work)
    str_hash = {}
    
    # crawl data
    work.name.split(" ").each do |n|
      if str_hash.keys.include?(n)
        str_hash[n] *= 2
      else
        str_hash[n] = Search::HANDLE_WEIGHT
      end
    end
    work.tags.each do |tag|
      if str_hash.keys.include?(tag.name)
        str_hash[tag.name] *= 2
      else
        str_hash[tag.name] = Search::ARTICLE_TAG_WEIGHT
      end
    end
    work.users.each do |user|
        str_hash[user.handle] = Search::HANDLE_WEIGHT
    end

    # build string
    search_str = ""
    str_hash.each do |k,v|
      search_str << "#{URI.escape(k)}#{Search::WEIGHT_DELIM}#{URI.escape(v.to_s)}#{Search::TAG_DELIM}"
    end
    search_str = search_str.slice(0, search_str.length-1)

    # finish up
    work.search_str = search_str
    work.save
    return search_str
    
  end

  # Gives a numerical score for how well search terms match against
  # the search string.
  #
  # @params  terms        array of keywords
  # @params  search_str   search string
  #
  # @returns              Numerical match score
  def Search.match(terms, search_str)
    hash = build_hash_from_str(search_str)
    terms.each { |t| t.upcase! }
    score = 0.0

    terms.each do |term|
      score += hash[term] if hash.keys.include?(term)
      hash.keys.each do |k|
        score += (hash[k]*Search::PARTIAL_MATCH_WEIGHT) if k.include?(term)
      end
    end

    return score
  end

  # Takes an array of search strings, and ranks them against 
  # the given terms.
  #
  # @params  terms              array of keywords
  # @params  search_str_array   array of search_strs
  # 
  # @returns                    ordered array of terms
  def Search.search_and_rank(terms, search_str_array)
    rank_hash = {}

    # score
    search_str_array.each do |ss|
      score = match(terms, ss)
      rank_hash[ss] = score if score > 0
    end

    #rank
    strs = rank_hash.keys
    strs.sort! {|x,y| rank_hash[y] <=> rank_hash[x]}

    return strs
  end

  # Gives a numerical (0 < n < 1) value of how matched a user is
  # against a given works and its authors tags.
  #
  # @params  user_test          user to test
  # @params  work_truth         work to test against
  #
  # @returns                    score
  def Search.user_work_matchedness(user_test, work_truth)
  end

  #private

  def Search.build_hash_from_str(str)
    tags = str.split(Search::TAG_DELIM)
    pre_hash = []
    tags.each { |t| pre_hash << t.split(Search::WEIGHT_DELIM) }

    decode_hash = Hash[pre_hash]
    hash = {}
    decode_hash.each do |k,v|
      hash[URI.unescape(k).upcase] = URI.unescape(v)
    end

    hash.each { |k,v| hash[k] = hash[k].to_f }
    return hash
  end

end

