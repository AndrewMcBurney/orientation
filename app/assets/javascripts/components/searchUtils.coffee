# *************************************
#
#   Search Utils
#   -> Helper functions for algolia-
#      search autocomplete
#
# *************************************

# Returns JSON object denoting filter for client-side algoliasarch autocomplete
@Orientation.getFilter = ->
  filterData = $('#algolia-filter').val()
  if filterData then { tagFilters: filterData } else {}


# Merges two JSON objects to resulting 'search_options' object for use with
# algoliasearch autocomplete
@Orientation.searchOptions = ->
  filter = Orientation.getFilter()
  $.extend({ hitsPerPage: 5 }, filter)
