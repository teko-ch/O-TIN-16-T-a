require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

# An extension that automatically hides blocks marked with the style
# "solution" and adds a link to the previous element that has the style
# "title" that allows displaying the "solution".
#
# Usage
#
#   = View Solution Sample
#
#   .This will have a link next to it
#   ----
#   * always displayed
#   * always displayed 2
#   ----
#
#   [.solution]
#   ====
#   * hidden till clicked
#   * hidden till clicked 2
#   ====
#
#
class ViewResultDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl
  at_location :head

  def process doc
    styles = %(<style>
.exampleblock a.view-solution, .listingblock a.view-solution {
  float: right;
  font-weight: normal;
  text-decoration: none;
  font-size: 0.9em;
  line-height: 1.4;
  margin-top: 0.15em;
}
</style>)

  scripts = %(<script>
function toggle_solution_block(e) {
  e.preventDefault();
  var linkNode = e.target.nodeName == 'I' ? e.target.parentNode :  e.target;
  var solutionNode = linkNode.parentNode.parentNode.nextElementSibling;
  if (getComputedStyle(solutionNode).display == 'none') {
    linkNode.innerHTML = 'Solution <i class="fa fa-chevron-circle-up" aria-hidden="true"></i>';
    solutionNode.style.display = '';
  } else {
    linkNode.innerHTML = 'Solution <i class="fa fa-chevron-circle-down" aria-hidden="true"></i>';
    solutionNode.style.display = 'none';
  }
  return false;
}

document.addEventListener('DOMContentLoaded', function() {
  [].forEach.call(document.querySelectorAll('.solution'), function(resultNode) {
    resultNode.style.display = 'none';
    var viewLink = document.createElement('a');
    viewLink.className = 'view-solution';
    viewLink.href = '#';
    viewLink.innerHTML = 'Solution <i class="fa fa-chevron-circle-down" aria-hidden="true"></i>';
    resultNode.previousElementSibling.querySelector('.title').appendChild(viewLink);
    viewLink.addEventListener('click', toggle_solution_block);
  });
});
</script>);

    [styles, scripts].join "\n"
  end
end
