function open_settings() {
  const settings = document.getElementById("settings");
  settings.classList.remove("hidden");

  const main = document.getElementById("main");
  main.classList.add("blur-sm");
}

function close_settings() {
  const settings = document.getElementById("settings");
  settings.classList.add("hidden");

  const main = document.getElementById("main");
  main.classList.remove("blur-sm");
}

function open_poll_results() {
  document.getElementById("poll-content").classList.remove("hidden");
  document.getElementById("main").classList.add("blur-sm");  
}

function close_poll_results() {
  document.getElementById("poll-content").classList.add("hidden");
  document.getElementById("main").classList.remove("blur-sm");
}


function toggle_admin_information(type, id) {
  const info = document.getElementById(`${type}-info-${id}`)
  const toggle = document.getElementById(`${type}-toggle-${id}`)
  info.classList.toggle("hidden")

  if (toggle.classList.contains("fa-angle-right")) {
    toggle.classList.remove("fa-angle-right");
    toggle.classList.add("fa-angle-down");
  } else {
    toggle.classList.remove("fa-angle-down");
    toggle.classList.add("fa-angle-right");
  }
}

function update_poll_editor(pressed_id) {
  const answers = document.getElementById("ans-types");
  answers.classList.remove("hidden");
  pressed_id == "scale-btn" ? answers.classList.add("hidden") : answers.classList.remove("hidden");
}


// Only allows removal of the answer if there are three or more answers
function remove_poll_answer(button) {
  answer_list = document.getElementById("answer-list");
  if (answer_list.childElementCount > 2) {
    button.parentNode.remove(); 
  } else {
    notify("Polls require at least two answers!")
  }

}

function toggle_home_menu() {
  sidebar = document.getElementById("left-sidebar");
  content = document.getElementById("home-content");

  if (sidebar.classList.contains("hidden")) {
    sidebar.classList.remove("hidden");
    sidebar.classList.add("w-full");
    content.classList.add("hidden");
  } else {
    sidebar.classList.add("hidden");
    sidebar.classList.remove("w-full");
    content.classList.remove("hidden");
  }
}


// var reloaded = false;
//
// function set_reload_listener() {
//   var reloaded = true;
//   setTimeout(function() { reloaded = false; }, 1000);
// }

var previousScroll = 1;

function set_scroll(div) {
  console.log(div.scrollTop, previousScroll);
  previousScroll = div.scrollTop;
}

function trigger_reload(div) {
  if (div.scrollTop === 0 && previousScroll === 0) {
    htmx.ajax("GET", "/reload");
    previousScroll = 1;
  }
}


function update_answer_editor(poll_type) {

  editor = document.getElementById("answer-editor");
  var endpoint_editor = document.getElementById("endpoint-container");

  // Hack
  document.getElementById("question-lbl").innerHTML = poll_type.split("_").map((s) => s[0].toUpperCase() + s.substring(1)).toString().replace(",", " ");

  if (poll_type == "numeric_scale") {
    endpoint_editor.classList.remove("hidden");
    editor.classList.add("hidden");
    document.getElementById("question-lbl").innerHTML = "Scale";
  } else {
    endpoint_editor.classList.add("hidden");
    editor.classList.remove("hidden");
  }

}

function toggle_comments(poll_id) {
  comments = document.getElementById("poll-comments-" + poll_id);
  toggle = document.getElementById("comments-toggle-" + poll_id);

  if (comments.classList.contains("hidden")) {

    // Close all dropdowns
    dropdowns = document.getElementsByClassName("poll-comments");
    for (var i = 0; i < dropdowns.length; i++) {
      id = dropdowns[i].getAttribute("id").substr(14);
      document.getElementById("poll-comments-" + id).classList.add("hidden");
      // document.getElementById("comments-toggle-" + id).innerHTML = "Show Comments";
    }

    // Open the current dropdown
    comments.classList.remove("hidden")
    // toggle.innerHTML = "Hide Comments"

  } else {
    comments.classList.add("hidden")
    // toggle.innerHTML = "Show Comments"
  }

}

function show_reply_input(comment_id) {
  reply_input = document.getElementById("reply-input-" + comment_id);
  reply_input.classList.remove("hidden");
}

function hide_reply_input(comment_id) {
  reply_input = document.getElementById("reply-input-" + comment_id);
  reply_input.classList.add("hidden");
}

function toggle_replies(comment_id) {

  reply_list = document.getElementById("reply-list-" + comment_id);
  reply_icon = document.getElementById("reply-icon-" + comment_id);

  if (reply_icon.classList.contains("fa-angle-right")) {

    // Close all the other reply dropdowns
    dropdowns = document.getElementsByClassName("poll-replies");
    for (var i = 0; i < dropdowns.length; i++) {
      id = dropdowns[i].getAttribute("id").substr(11);
      document.getElementById("reply-list-" + id).classList.add("hidden");
      document.getElementById("reply-icon-" + id).classList.remove("fa-angle-down");
      document.getElementById("reply-icon-" + id).classList.add("fa-angle-right");
    }

    // Open this reply dropdown
    reply_list.classList.remove("hidden");
    reply_icon.classList.remove("fa-angle-right");
    reply_icon.classList.add("fa-angle-down");

  } else {
    reply_list.classList.add("hidden");
    reply_icon.classList.remove("fa-angle-down");
    reply_icon.classList.add("fa-angle-right");
  }

}

function toggle_filter_dropdown() {
  document.getElementById("filter-dropdown").classList.toggle("hidden");
}

function toggle_filter_time_dropdown() {
  document.getElementById("filter-time-dropdown").classList.toggle("hidden");
}


function toggle_board_dropdown() {
  document.getElementById("board-dropdown").classList.toggle("hidden");
}


// sinful global variable
var activeTierItem = {}

function tier_select(element, poll_id) {
  activeTierItem["poll_id"] = poll_id;
  activeTierItem["element"] = element.parentNode;
}

function handle_tier_select(poll_id, tier) {

  if (activeTierItem["poll_id"] == poll_id) {

    item = activeTierItem["element"];
    input = item.querySelector("input[name='answer_tier']");
    input.value = tier;

    container = document.getElementById(`${tier}-content-${poll_id}`);
    item.parentNode.removeChild(item);
    container.appendChild(item);

  }

  activeTierItem = {};

}

function toggle_custom_endpoints(toggle) {
  document.getElementById("endpoint-editor").classList.toggle("hidden");
  document.getElementById("endpoint-left").value = "";
  document.getElementById("endpoint-right").value = "";
}

function toggle_tier_results(toggle) {
  [document.getElementById(`tier-results-user-${toggle.id}`), document.getElementById(`tier-results-average-${toggle.id}`)].forEach((e) => e.classList.toggle("hidden"));
  document.getElementById(`text-${toggle.id}`).innerHTML == "Average" ? document.getElementById(`text-${toggle.id}`).innerHTML = "You" : document.getElementById(`text-${toggle.id}`).innerHTML = "Average";
}



// Might still need this for mobile
function toggle_poll_results(toggle, url) {
  
  [document.getElementById("my-polls"), document.getElementById("history-polls")].forEach((e) => e.classList.toggle("hidden"));

}

function handle_rank_select(poll_id, ans_id) {

  var opts = document.getElementById(`ans-container-${poll_id}`).querySelectorAll("input");
  var rs = document.getElementById(`checkbox-${ans_id}`);

  // count how many check box items are clicked AFTER the one that called this function was clicked
  var checkCount = Array.from(opts).map((b) => b.checked ? 1 : 0).reduce((acc, curr) => acc + curr);

  document.getElementById(`rank-num-${ans_id}`).innerHTML = checkCount.toString();
  document.getElementById(`rank-num-${ans_id}`).classList.remove("hidden");
  document.getElementById(`rank-input-${ans_id}`).value = checkCount.toString();

  // Ensure the button cannot be clicked again
  rs.disabled = true;

}

function clear_ranking(poll_id) {
  document.getElementById(`ans-container-${ poll_id }`).querySelectorAll("input").forEach((e) => {

    if (e.checked) {
      // remove the ranking text from the label
      var ans_id = e.parentNode.querySelector("input").id.toString();
      var ans_id_num = ans_id.substring(ans_id.indexOf("-") + 1);
      document.getElementById(`rank-num-${ans_id_num}`).classList.add("hidden");
      document.getElementById(`rank-num-${ans_id_num}`).innerHTML = "";
      document.getElementById(`rank-input-${ans_id_num}`).value = "";
    }
    // reset to default behaviour
    e.checked = false;
    e.disabled = false;
  })
}
