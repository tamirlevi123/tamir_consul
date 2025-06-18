function initializeDecisionTree(railsTree, nodeIds, userSignedIn) {
  console.log('initializeDecisionTree called');
  
  // Wait for Treant to be available
  if (typeof Treant === 'undefined') {
    console.log('Treant not loaded yet, waiting...');
    setTimeout(function() {
      initializeDecisionTree(railsTree, nodeIds, userSignedIn);
    }, 100);
    return;
  }

  // Recursively add HTML for each node
  function buildNodeStructure(node) {
    var nodeObj = {
      innerHTML: '<div>' + node.text.name + '</div>',
      HTMLid: 'node-' + node.id
    };
    if (node.children && node.children.length > 0) {
      nodeObj.children = node.children.map(buildNodeStructure);
    }
    return nodeObj;
  }

  function addNodeIds(node, id) {
    node.id = id;
    if (node.children) {
      for (var i = 0; i < node.children.length; i++) {
        addNodeIds(node.children[i], nodeIds.shift());
      }
    }
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

  addNodeIds(railsTree, nodeIds.shift());

  var treantConfig = {
    chart: {
      container: "#tree-simple",
      node: { HTMLclass: 'nodeExample1' },
      connectors: { type: 'step' },
      animation: { nodeAnimation: "easeOutBounce", nodeSpeed: 700, connectorsAnimation: "bounce", connectorSpeed: 700 }
    },
    nodeStructure: buildNodeStructure(railsTree)
  };

  new Treant(treantConfig, function() {
    nodeIds.forEach(function(id) {
      var nodeDiv = document.getElementById('node-' + id);
      if (nodeDiv) {
        if (userSignedIn) {
          // Add speech bubble icon for logged-in users
          var icon = document.createElement('img');
          icon.src = '/speech_bubble.jpg';
          icon.alt = 'Add Child Node';
          icon.className = 'speech-bubble-icon';
          icon.title = 'Add Child Node';
          icon.onclick = function(e) {
            e.stopPropagation();
            document.getElementById('addChildModal').style.display = 'block';
            document.getElementById('modal_parent_id').value = id;
            // Reset form fields
            document.getElementById('node_content_field').value = '';
            document.getElementById('node_url_field').value = '';
            document.getElementById('urlPreview').style.display = 'none';
            document.getElementById('confirmUrlBtn').style.display = 'none';
            document.getElementById('url_confirmed_field').value = false;
            document.getElementById('addNodeSubmit').disabled = true;
          };
          nodeDiv.appendChild(icon);
        }
        // Add click handler for selection (for all users)
        nodeDiv.onclick = function(e) {
          e.stopPropagation();
          // Deselect all nodes
          document.querySelectorAll('.nodeExample1.selected-node').forEach(function(n) {
            n.classList.remove('selected-node');
          });
          // Select this node
          nodeDiv.classList.add('selected-node');
        };
      }
    });
    // Deselect nodes when clicking outside (for all users)
    document.body.addEventListener('click', function(e) {
      if (!e.target.classList.contains('nodeExample1')) {
        document.querySelectorAll('.nodeExample1.selected-node').forEach(function(n) {
          n.classList.remove('selected-node');
        });
      }
    });
  });

  if (userSignedIn) {
    // Modal logic for logged-in users
    var modal = document.getElementById('addChildModal');
    var closeBtn = document.getElementById('closeAddChildModal');
    closeBtn.onclick = function() { modal.style.display = 'none'; };
    window.onclick = function(event) {
      if (event.target == modal) { modal.style.display = 'none'; }
    };

    // URL validation and confirmation logic
    var urlField = document.getElementById('node_url_field');
    var confirmBtn = document.getElementById('confirmUrlBtn');
    var urlPreview = document.getElementById('urlPreview');
    var addNodeSubmit = document.getElementById('addNodeSubmit');
    var urlConfirmedField = document.getElementById('url_confirmed_field');
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

    urlField.addEventListener('input', function() {
      var url = urlField.value.trim();
      urlValid = validateUrl(url);
      urlConfirmed = false;
      urlConfirmedField.value = false;
      addNodeSubmit.disabled = true;
      if (urlValid) {
        urlPreview.textContent = url;
        urlPreview.style.display = 'block';
        confirmBtn.style.display = 'inline-block';
      } else {
        urlPreview.style.display = 'none';
        confirmBtn.style.display = 'none';
      }
    });
    console.log('Added event listener for urlField input');

    confirmBtn.addEventListener('click', function() {
      urlConfirmed = true;
      urlConfirmedField.value = true;
      confirmBtn.textContent = 'URL Confirmed';
      confirmBtn.disabled = true;
      addNodeSubmit.disabled = false;
    });
    console.log('Added event listener for confirmBtn click');

    document.getElementById('node_content_field').addEventListener('input', function() {
      var content = this.value.trim();
      var url = urlField.value.trim();
      if ((content && !url) || (url && urlConfirmed)) {
        addNodeSubmit.disabled = false;
      } else {
        addNodeSubmit.disabled = true;
      }
    });
    console.log('Added event listener for node_content_field input');
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