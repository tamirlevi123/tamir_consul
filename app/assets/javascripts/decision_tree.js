function initializeDecisionTree(railsTree, nodeIds, userSignedIn) {
  console.log('initializeDecisionTree called with:', { railsTree, nodeIds, userSignedIn });
  
  // Wait for Treant to be available
  if (typeof Treant === 'undefined') {
    console.log('Treant not loaded yet, waiting...');
    setTimeout(function() {
      initializeDecisionTree(railsTree, nodeIds, userSignedIn);
    }, 100);
    return;
  }
  console.log('Treant is loaded and available');

  // Recursively add HTML for each node
  function buildNodeStructure(node) {
    console.log('Building node structure for:', node);
    var nodeObj = {
      text: { name: node.text.name },
      HTMLid: 'node-' + node.id,
      connectors: {
        style: {
          'stroke': '#1976d2',
          'arrow-end': 'oval-wide-long'
        }
      }
    };
    if (node.children && node.children.length > 0) {
      nodeObj.children = node.children.map(buildNodeStructure);
    }
    return nodeObj;
  }

  if (!railsTree) {
    console.log('No tree data to render.');
    return;
  }

  // Clear existing tree if any
  var container = document.getElementById('tree-simple');
  if (container) {
    container.innerHTML = '';
  }

  console.log('Tree structure before rendering:', railsTree);

  var treantConfig = {
    chart: {
      container: "#tree-simple",
      node: { 
        HTMLclass: 'nodeExample1',
        collapsable: true
      },
      connectors: { 
        type: 'step',
        style: {
          'stroke-width': 2
        }
      },
      animation: { 
        nodeAnimation: "easeOutBounce",
        nodeSpeed: 700,
        connectorsAnimation: "bounce",
        connectorSpeed: 700
      }
    },
    nodeStructure: buildNodeStructure(railsTree)
  };

  console.log('Creating Treant with config:', treantConfig);
  new Treant(treantConfig, function() {
    if (userSignedIn) {
      nodeIds.forEach(function(id) {
        var nodeDiv = document.getElementById('node-' + id);
        if (nodeDiv) {
          console.log('Setting up node:', id);
          // Add speech bubble icon for logged-in users
          var icon = document.createElement('div');
          icon.innerHTML = `<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M16 2C8.26801 2 2 7.26801 2 14C2 17.326 3.38376 20.3341 5.65454 22.5013C5.77231 22.6135 5.84201 22.7678 5.84201 22.9293V29.2858C5.84201 29.7209 6.32327 29.9848 6.69379 29.7608L12.2225 26.5159C12.3857 26.4205 12.5752 26.3901 12.7584 26.4301C13.7843 26.6754 14.8696 26.8071 16 26.8071C23.732 26.8071 30 21.5391 30 14.8071C30 7.26801 23.732 2 16 2Z" fill="#1976d2"/>
          </svg>`;
          icon.className = 'speech-bubble-icon';
          icon.title = 'Add Child Node';
          console.log('Creating icon for node:', id);
          nodeDiv.appendChild(icon);
          console.log('Icon added to node');
          
          icon.onclick = function(e) {
            e.stopPropagation();
            console.log('Setting up node:', id);
            var $modal = $('#addNodeModal');
            if ($modal.length) {
              $('#node_parent_id').val(id);
              // Reset form fields
              $('#node_content').val('');
              $('#node_url').val('');
              $('#urlPreview').hide();
              $('#confirmUrlBtn').hide();
              $('#url_confirmed').val(false);
              $('#addNodeSubmit').prop('disabled', true);
              
              $modal.foundation('open');
            } else {
              console.error('Modal not found');
            }
          };

          // Add click handler for selection
          nodeDiv.onclick = function(e) {
            e.stopPropagation();
            console.log('Node clicked:', id);
            // Deselect all nodes
            document.querySelectorAll('.nodeExample1.selected-node').forEach(function(n) {
              n.classList.remove('selected-node');
            });
            // Select this node
            nodeDiv.classList.add('selected-node');
            console.log('Node selected, classes:', nodeDiv.className);
          };
        }
      });
    }

    // Deselect nodes when clicking outside
    document.body.addEventListener('click', function(e) {
      if (!e.target.closest('.nodeExample1')) {
        document.querySelectorAll('.nodeExample1.selected-node').forEach(function(n) {
          n.classList.remove('selected-node');
        });
      }
    });
  });

  if (userSignedIn) {
    // URL validation and confirmation logic
    var urlField = $('#node_url');
    var confirmBtn = $('#confirmUrlBtn');
    var urlPreview = $('#urlPreview');
    var addNodeSubmit = $('#addNodeSubmit');
    var urlConfirmedField = $('#url_confirmed');
    var urlValid = false;
    var urlConfirmed = false;

    function validateUrl(url) {
      try {
        var u = new URL(url);
        return u.protocol === 'http:' || u.protocol === 'https:';
      } catch (e) {
        return false;
      }
    }

    urlField.on('input', function() {
      var url = urlField.val().trim();
      urlValid = validateUrl(url);
      urlConfirmed = false;
      urlConfirmedField.val(false);
      addNodeSubmit.prop('disabled', true);
      if (urlValid) {
        urlPreview.text(url);
        urlPreview.show();
        confirmBtn.show();
      } else {
        urlPreview.hide();
        confirmBtn.hide();
      }
    });
    console.log('Added event listener for urlField input');

    confirmBtn.on('click', function() {
      urlConfirmed = true;
      urlConfirmedField.val(true);
      confirmBtn.text('URL Confirmed');
      confirmBtn.prop('disabled', true);
      addNodeSubmit.prop('disabled', false);
    });
    console.log('Added event listener for confirmBtn click');

    $('#node_content').on('input', function() {
      var content = $(this).val().trim();
      var url = urlField.val().trim();
      if ((content && !url) || (url && urlConfirmed)) {
        addNodeSubmit.prop('disabled', false);
      } else {
        addNodeSubmit.prop('disabled', true);
      }
    });
    console.log('Added event listener for node_content input');
  }
}

// Initialize on both DOMContentLoaded and turbolinks:load
document.addEventListener('DOMContentLoaded', function() {
  console.log('DOMContentLoaded event fired');
  if (window.decisionTreeData) {
    initializeDecisionTree(window.decisionTreeData.railsTree, window.decisionTreeData.nodeIds, window.decisionTreeData.userSignedIn);
  }
});

document.addEventListener('turbolinks:load', function() {
  console.log('turbolinks:load event fired');
  if (window.decisionTreeData) {
    initializeDecisionTree(window.decisionTreeData.railsTree, window.decisionTreeData.nodeIds, window.decisionTreeData.userSignedIn);
  }
}); 