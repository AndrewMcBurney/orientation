# *************************************
#
#   Document Ready
#
# *************************************

jQuery ($) ->

  # ----- Functions ----- #
  Orientation.accordion()
  Orientation.autoSubmit()
  Orientation.dropdown()
  Orientation.headingLink()
  Orientation.shortcut()

  Orientation.search
    hiddenClass: 'dn'

  # ----- Modules ----- #

  Orientation.editor.init()
  Orientation.selectText.init()
  Orientation.tableBank.init()

  # ----- Vendor ----- #

  # Bootstrap

  $('[data-toggle="tooltip"]').tooltip
    container: 'body'

  # jquery-ujs

  $('#category_article_tokens').tokenInput '/articles.json',
      propertyToSearch: 'title',
      prePopulate: $('#category_article_tokens').data('load')
      preventDuplicates: true
    Orientation.algoliasearch('Category')

  $('#article_tag_tokens').tokenInput '/tags.json',
      prePopulate: $('#article_tag_tokens').data('load')
      preventDuplicates: true
    Orientation.algoliasearch('Article')

  $('#article_category_tokens').tokenInput '/categories.json',
      propertyToSearch: 'label',
      prePopulate: $('#article_category_tokens').data('load')
      preventDuplicates: true
    Orientation.algoliasearch('Article')
