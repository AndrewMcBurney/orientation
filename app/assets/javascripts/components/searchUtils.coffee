# *************************************
#
#   Search Utils
#   -> Helper functions for algolia-
#      search autocomplete
#
# *************************************

# Returns JSON object denoting filter for client-side algoliasarch autocomplete
@Orientation.matchFilter = ( title ) ->
  filter = title.split(' ')[0].toLowerCase() || ''

  if filter is 'fresh' or filter is 'stale' or filter is 'outdated' or
     filter is 'archived'
    { tagFilters: filter }
  else
    {}


# Merges two JSON objects to resulting 'search_options' object for use with
# algoliasearch autocomplete
@Orientation.searchOptions = () ->
  filter = Orientation.matchFilter(document.title)
  $.extend({ hitsPerPage: 5 }, filter)
