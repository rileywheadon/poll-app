const getNodeIndex = elem => [...elem.parentNode.children].indexOf(elem)

// Fully cancels an event's behaviour 
function cancelDefault(e) {
  e.preventDefault();
  e.stopPropagation();
  return false;
}

// DRAG AND DROP HANDLERS FOR RANKED_POLL
function rankedDragStart(e) {
  const index = getNodeIndex(e.target);  
  e.dataTransfer.setData("text/plain", index);
}

function rankedDragEnter(e) {
  cancelDefault(e);
  e.target.classList.add("text-zinc-400")
}

function rankedDragExit(e) {
  cancelDefault(e);
  e.target.classList.remove("text-zinc-400")
}

function rankedDrop(e) {
  cancelDefault(e);

  // get new and old index
  let oldIndex = e.dataTransfer.getData("text/plain");
  let target = e.target;
  let newIndex = getNodeIndex(e.target);

  // Remove the old element
  let parent = e.currentTarget.parentNode;
  let droppedElement = parent.children[oldIndex];
  droppedElement.remove();

  // Remove hover effect on target and droppedElement
  target.classList.remove("text-zinc-400");
  droppedElement.classList.remove("text-zinc-400");

  // Insert the dropped element at the new place
  if (newIndex < oldIndex) {
    parent.insertBefore(droppedElement, target);
  } else {
    parent.insertBefore(droppedElement, target.nextSibling);
  }

}

// DRAG AND DROP HANDLERS FOR TIER_POLL
var activeTierItem = null;

function tierDragStart(e) {
  activeTierItem = e.target;
}

function tierDragEnter(e) {
  cancelDefault(e);
}

function tierDragExit(e) {
  cancelDefault(e);
}

function tierDrop(e) {
  cancelDefault(e);

  // Get the tier that the item is being dropped into
  var tier = null;
  for (const className of e.target.classList) {
    if (className.startsWith("tier")) {
      tier = className.split("-").pop();
    }
  }

  // Add or change a hidden input tag containing the tier of the item
  inputTag = activeTierItem.querySelector("input[name='answer_tier'")
  if (inputTag != null) { 
    inputTag.setAttribute("value", tier);
  } else {
    // Add a hidden input tag to the activeTierItem element with the tier
    var newInput = document.createElement("input");
    newInput.setAttribute("type", "hidden"); 
    newInput.setAttribute("name", "answer_tier"); 
    newInput.setAttribute("value", tier); 
    activeTierItem.appendChild(newInput);
  }

  activeTierItem.remove();
  e.target.appendChild(activeTierItem);
  activeTierItem = null;
}
