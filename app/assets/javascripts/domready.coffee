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

  $('#article_tag_tokens').tokenInput '/tags.json',
    prePopulate: $('#article_tag_tokens').data('load')
    preventDuplicates: true

  client = algoliasearch('BTKJC5GJQT', 'c202114b44ae7f6dd4e5409af4d55aa1');
  index = client.initIndex('Article');

  ac = autocomplete('#search', { hint: true }, [
    {
      source: autocomplete.sources.hits(index, { hitsPerPage: 5 }),
      displayKey: 'title',
      templates: {
        suggestion: (hit) ->
          return '<div class="search-result-title">' +
          hit._highlightResult.title.value + '</div>' +
          '<div class="search-result-content-snippet">"...' +
          hit._snippetResult.content.value + '..."</div>'
      }
    }
  ]).on('autocomplete:selected', (event, suggestion, dataset) ->
    $('#search').trigger( 'submit' )
  );
