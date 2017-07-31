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

  $('#article_tag_tokens').tokenInput '/tags.json',
      prePopulate: $('#article_tag_tokens').data('load')
      preventDuplicates: true

  $('#article_category_tokens').tokenInput '/departments.json',
      propertyToSearch: 'label',
      prePopulate: $('#article_category_tokens').data('load')
      preventDuplicates: true

  # Use 'User' for algoliasearch index for 'authors' controller, default to
  # 'Article' for everything else
  if $('#controller_name').val() is 'authors'
    Orientation.algoliasearch('User')
  else
    Orientation.algoliasearch('Article')
