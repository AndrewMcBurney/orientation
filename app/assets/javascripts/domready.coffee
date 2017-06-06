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

  console.log($('#article_tag_tokens'))

  $('[data-toggle="tooltip"]').tooltip
    container: 'body'

  # jquery-ujs

  $('#article_tag_tokens').tokenInput '/tags.json',
    prePopulate: $('#article_tag_tokens').data('load')
    preventDuplicates: true

  client = algoliasearch('BTKJC5GJQT', 'c202114b44ae7f6dd4e5409af4d55aa1');
  console.log('client: ', client)
  index = client.initIndex('Article');
  console.log('index: ', index)

 # $('#search').on('input', ->
 #   console.log('searching for: ', $(this).val())
 #   index.search($(this).val(), {hitsPerPage: 10, page: 0})
 #   .then (content) ->
 #     console.log(content);
 #     $results = content
 #   .catch (err) ->
 #     console.error(err);
 # )

  ac = autocomplete('#search', { hint: true }, [
    {
      source: autocomplete.sources.hits(index, { hitsPerPage: 5 }),
      displayKey: 'title',
      templates: {
        suggestion: (hit) ->
          return '<div class="search-result-title"> <span class="search-result-heading">title:</span> ' +
          hit._highlightResult.title.value +
          '</div>' + '<div class="search-result-content-snippet"> <span class="search-result-heading">content:</span> "...' +
          hit._snippetResult.content.value + '..."</div>'
      }
    }
  ]).on('autocomplete:selected', (event, suggestion, dataset) ->
    $('#search').trigger( 'submit' )
    console.log(suggestion, dataset);
    console.log('bro. im trash.');
  );
