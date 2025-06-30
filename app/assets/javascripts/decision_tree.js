document.addEventListener("turbolinks:load", function() {
  console.log("turbolinks:load event fired. Initializing tree.");
  
  const treeContainer = document.getElementById('tree-simple');
  if (treeContainer && window.decisionTreeData) {
    // Clear any previous tree to prevent duplicates on reloads
    treeContainer.innerHTML = '';
    initializeDecisionTree(
      window.decisionTreeData.railsTree,
      window.decisionTreeData.nodeIds,
      window.decisionTreeData.userSignedIn
    );
  } else {
    console.log("Could not initialize tree. Missing container or data.");
  }
});

function initializeDecisionTree(railsTree, nodeIds, userSignedIn) {
  console.log('--- initializeDecisionTree STARTS ---');
  
  if (typeof $ !== 'undefined' && typeof $.fn.foundation !== 'undefined' && !$('body').attr('data-zf-loaded')) {
    $(document).foundation();
  }
  
  if (typeof Treant === 'undefined') {
    console.log('Treant library not found. Aborting.');
    return;
  }
  
  if (!railsTree) {
    console.log('No tree data found. Aborting.');
    return;
  }

  function buildNodeStructure(node) {
    console.log(`Building node structure for: node #${node.id}`);
    
    var addNodeIcon = '';
    var voteData = node.vote_data || { likes: 0, dislikes: 0, total: 0, likes_percentage: '0%', dislikes_percentage: '0%' };

    // Headline and content preview logic
    var headline = node.text.headline || '';
    var content = node.text.content || '';
    var preview = content.split('\n')[0].slice(0, 100);
    var isLong = content.length > preview.length;
    var rest = isLong ? content.slice(preview.length).replace(/^\n?/, '') : '';

    var contentHtml = `<h3 class='node-headline'>${headline}</h3>`;
    if (content) {
      contentHtml += `<div class='node-content-preview' style='${isLong ? '' : 'margin-bottom: 1em;'}; font-weight: normal;'>`;
      contentHtml += `<span class='preview-text'>${preview}${isLong ? '...' : ''}</span>`;
      if (isLong) {
        contentHtml += `<button class='button small show-more-btn'>הצג עוד</button>`;
      }
      contentHtml += `</div>`;
      if (isLong) {
        contentHtml += `<div class='node-full-content' style='display: none; font-weight: normal;'><p>${rest}</p><button class='button small show-less-btn'>הצג פחות</button></div>`;
      }
    }

    var votingHtml = `
      <div class="node-voting-section">
        <div class="decision-node-votes">
          <div class="in-favor">
            <button class="vote-button like-button" data-node-id="${node.id}" data-vote-type="like" data-tree-id="${railsTree.tree_id || 1}" ${!userSignedIn ? 'disabled' : ''}>
              <i class="fas fa-thumbs-up"></i>
            </button>
            <div class="vote-count">${voteData.likes}</div>
            <div class="percentage">${voteData.likes_percentage}</div>
          </div>
          <div class="against">
            <button class="vote-button dislike-button" data-node-id="${node.id}" data-vote-type="dislike" data-tree-id="${railsTree.tree_id || 1}" ${!userSignedIn ? 'disabled' : ''}>
              <i class="fas fa-thumbs-down"></i>
            </button>
            <div class="vote-count">${voteData.dislikes}</div>
            <div class="percentage">${voteData.dislikes_percentage}</div>
          </div>
        </div>
        <div class="total-votes">${voteData.total} total votes</div>
      </div>
    `;

    if (userSignedIn) {
      addNodeIcon = `
        <div class="speech-bubble-icon" title="Add Child Node">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11h-4v4h-2v-4H7v-2h4V7h2v4h4v2z" fill="#1976d2"/></svg>
        </div>
      `;
    }
    
    var nodeObj = {
      innerHTML: `<div class="node-content-wrapper"><div class="node-content">${contentHtml}</div>${votingHtml}</div>${addNodeIcon}`,
      HTMLid: 'node-' + node.id,
      HTMLclass: 'node-' + (node.child_type || 'default').toLowerCase(),
      connectors: {
        style: { 'stroke': '#ccc', 'stroke-width': 2, 'arrow-end': 'oval-wide-long' }
      }
    };

    if (node.children && node.children.length > 0) {
      nodeObj.children = node.children.map(buildNodeStructure);
    }
    return nodeObj;
  }

  var treantConfig = {
    chart: {
      container: "#tree-simple",
      levelSeparation: 100,
      siblingSeparation: 60,
      subTeeSeparation: 60,
      node: { HTMLclass: 'nodeExample1' },
      connectors: { type: 'step' }
    },
    nodeStructure: buildNodeStructure(railsTree)
  };

  console.log('Creating Treant with config:', treantConfig);
  new Treant(treantConfig);
  
  // Add a click listener for anonymous users
  if (!userSignedIn) {
    const treeContainer = document.getElementById('tree-simple');
    treeContainer.addEventListener('click', function(e) {
      // Prevent any node interaction for anonymous users
      e.preventDefault();
      e.stopPropagation();
      
      // Display a flash message
      const flashContainer = document.querySelector('.flash-container');
      if (flashContainer) {
        const message = treeContainer.dataset.loginToEditMessage;
        
        // Construct the flash message HTML based on _flash.html.erb
        const flashDiv = document.createElement('div');
        flashDiv.id = 'flash_notice'; // or 'flash_alert' for errors
        flashDiv.className = 'notice-container callout-slide';
        flashDiv.setAttribute('data-closable', '');
        flashDiv.innerHTML = `
          <div class="callout notice primary">
            <button class="close-button" aria-label="Dismiss alert" type="button" data-close>
              <span aria-hidden="true">&times;</span>
            </button>
            <div class="notice-text">
              ${message}
            </div>
          </div>
        `;
        
        flashContainer.appendChild(flashDiv);
        
        // Initialize Foundation on the new element
        $(flashDiv).foundation();
      }
    }, true); // Use capture phase to catch the event early
  }

  // Set initial button states and fill percentages from pre-loaded data
  nodeIds.forEach(function(nodeId) {
    const nodeElement = document.getElementById('node-' + nodeId);
    if (nodeElement) {
      const node = findNodeById(railsTree, nodeId);
      const voteData = node && node.vote_data;
      if (voteData) {
        updateVoteDisplay(nodeId, voteData); 
        if (userSignedIn) {
          updateButtonState(nodeId, voteData.user_vote);
        }
      }
    }
  });

  if (userSignedIn) {
    console.log("User is signed in. Setting up votes and listeners.");
    setupVotingListeners();
    setupNodeAdditionListeners();
  }
  console.log('--- initializeDecisionTree ENDS ---');
}

function findNodeById(node, id) {
  if (node.id == id) {
    return node;
  }
  if (node.children) {
    for (const child of node.children) {
      const found = findNodeById(child, id);
      if (found) {
        return found;
      }
    }
  }
  return null;
}

function setupVotingListeners() {
  console.log('setupVotingListeners called.');
  const treeContainer = document.getElementById('tree-simple');
  if (treeContainer.dataset.listenerAttached) {
    console.log("Listener already attached. Skipping.");
    return;
  }
  treeContainer.dataset.listenerAttached = 'true';
  treeContainer.addEventListener('click', function(e) {
    const button = e.target.closest('.vote-button');
    if (button) {
      e.preventDefault();
      e.stopPropagation();
      console.log('Vote button clicked.');
      
      const nodeId = button.dataset.nodeId;
      const voteType = button.dataset.voteType;
      const treeId = button.dataset.treeId;
      const isVoted = button.classList.contains('voted');
      
      if (isVoted) {
        console.log(`Removing vote for node #${nodeId}`);
        removeVote(treeId, nodeId, voteType);
      } else {
        console.log(`Adding '${voteType}' vote for node #${nodeId}`);
        addVote(treeId, nodeId, voteType);
      }
    }
  });
}

function setupNodeAdditionListeners() {
  console.log('setupNodeAdditionListeners called.');
  const treeContainer = document.getElementById('tree-simple');

  if (treeContainer.dataset.nodeAdditionListener) {
    console.log("Node addition listener already attached. Skipping.");
    return;
  }
  treeContainer.dataset.nodeAdditionListener = 'true';

  treeContainer.addEventListener('click', function(e) {
    const clickedIcon = e.target.closest('.speech-bubble-icon');
    const clickedNode = e.target.closest('.nodeExample1');
    const showMoreBtn = e.target.closest('.show-more-btn');
    const showLessBtn = e.target.closest('.show-less-btn');

    // Handle show more/less buttons
    if (showMoreBtn) {
      e.preventDefault();
      e.stopPropagation();
      const nodeContent = showMoreBtn.closest('.node-content');
      const fullContent = nodeContent.querySelector('.node-full-content');
      const showLessBtn = nodeContent.querySelector('.show-less-btn');
      
      fullContent.style.display = 'block';
      showMoreBtn.style.display = 'none';
      showLessBtn.style.display = 'inline-block';
      return;
    }

    if (showLessBtn) {
      e.preventDefault();
      e.stopPropagation();
      const nodeContent = showLessBtn.closest('.node-content');
      const fullContent = nodeContent.querySelector('.node-full-content');
      const showMoreBtn = nodeContent.querySelector('.show-more-btn');
      
      fullContent.style.display = 'none';
      showLessBtn.style.display = 'none';
      showMoreBtn.style.display = 'inline-block';
      return;
    }

    // Handle clicking the "add" icon, which takes precedence.
    if (clickedIcon) {
      e.stopPropagation();
      const parentNode = clickedIcon.closest('.nodeExample1');
      const nodeId = parentNode.id.replace('node-', '');
      
      console.log(`Add icon clicked for node #${nodeId}`);

      const $modal = $('#addNodeModal');
      if ($modal.length) {
        $('#node_parent_id').val(nodeId);
        // Reset form fields
        $('#node_headline').val('');
        $('#node_content').val('');
        $('#node_url').val('');
        
        // This assumes Foundation is available for the modal
        $modal.foundation('open');
      } else {
        console.error('Add node modal not found!');
      }
      return;
    }

    // Handle selecting/deselecting the node itself.
    if (clickedNode) {
      // If a node was clicked (but not the icon), toggle its selection.
      const isSelected = clickedNode.classList.contains('selected-node');
      
      // First, deselect all nodes.
      document.querySelectorAll('.nodeExample1.selected-node').forEach(node => {
        node.classList.remove('selected-node');
      });

      // If the clicked node was not already selected, select it.
      if (!isSelected) {
        clickedNode.classList.add('selected-node');
      }
    } else {
      // If the click was outside any node, deselect all.
      document.querySelectorAll('.nodeExample1.selected-node').forEach(node => {
        node.classList.remove('selected-node');
      });
    }
  });
}

function addVote(treeId, nodeId, voteType) {
  console.log(`Executing addVote AJAX call for node #${nodeId}`);
  const formData = new URLSearchParams();
  formData.append('node_vote[vote_type]', voteType);
  
  fetch(`/decision_trees/${treeId}/decision_nodes/${nodeId}/node_vote`, {
    method: 'POST',
    body: formData,
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  })
  .then(response => response.json())
  .then(data => {
    console.log(`Received response from addVote for node #${nodeId}:`, data);
    if (data.success) {
      updateVoteDisplay(nodeId, data.votes);
      updateButtonState(nodeId, data.votes.user_vote);
    } else {
      console.error('Error recording vote:', data.error);
    }
  })
  .catch(error => console.error('AJAX error in addVote:', error));
}

function removeVote(treeId, nodeId, voteType) {
  console.log(`Executing removeVote AJAX call for node #${nodeId}`);
  fetch(`/decision_trees/${treeId}/decision_nodes/${nodeId}/node_vote`, {
    method: 'DELETE',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    }
  })
  .then(response => response.json())
  .then(data => {
    console.log(`Received response from removeVote for node #${nodeId}:`, data);
    if (data.success) {
      updateVoteDisplay(nodeId, data.votes);
      updateButtonState(nodeId, null);
    } else {
      console.error('Error removing vote:', data.error);
    }
  })
  .catch(error => console.error('AJAX error in removeVote:', error));
}

function updateVoteDisplay(nodeId, voteData) {
  console.log(`Updating display for node #${nodeId} with data:`, voteData);
  const nodeElement = document.getElementById('node-' + nodeId);
  
  if (nodeElement) {
    const likesCount = nodeElement.querySelector('.in-favor .vote-count');
    const likesPercentageEl = nodeElement.querySelector('.in-favor .percentage');
    const dislikesCount = nodeElement.querySelector('.against .vote-count');
    const dislikesPercentageEl = nodeElement.querySelector('.against .percentage');
    const totalVotes = nodeElement.querySelector('.total-votes');
    
    const likeButton = nodeElement.querySelector('.like-button');
    const dislikeButton = nodeElement.querySelector('.dislike-button');

    if (likesCount) likesCount.textContent = voteData.likes || 0;
    if (likesPercentageEl) likesPercentageEl.textContent = voteData.likes_percentage || '0%';
    if (dislikesCount) dislikesCount.textContent = voteData.dislikes || 0;
    if (dislikesPercentageEl) dislikesPercentageEl.textContent = voteData.dislikes_percentage || '0%';
    if (totalVotes) totalVotes.textContent = `${voteData.total || 0} total votes`;

    if (likeButton) {
      likeButton.style.setProperty('--fill-percentage', voteData.likes_percentage || '0%');
    }
    if (dislikeButton) {
      dislikeButton.style.setProperty('--fill-percentage', voteData.dislikes_percentage || '0%');
    }
  } else {
    console.error('Could not find node element for ID:', nodeId);
  }
}

function updateButtonState(nodeId, userVote) {
  console.log(`Updating button state for node #${nodeId}. User vote is: ${userVote}`);
  const nodeElement = document.getElementById('node-' + nodeId);
  if (!nodeElement) return;
  
  const likeButton = nodeElement.querySelector('.like-button');
  const dislikeButton = nodeElement.querySelector('.dislike-button');

  // Reset both buttons
  likeButton.classList.remove('voted');
  dislikeButton.classList.remove('voted');

  if (userVote === 'like') {
    likeButton.classList.add('voted');
  } else if (userVote === 'dislike') {
    dislikeButton.classList.add('voted');
  }
} 