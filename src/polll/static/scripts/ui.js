function open_settings() {
  const main = document.getElementById("main");
  main.classList.add("blur-sm");
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

function update_answer_editor(poll_type) {

  editor = document.getElementById("answer-editor");
  // Hack
  document.getElementById("question-lbl").innerHTML = poll_type.split("_").map((s) => s[0].toUpperCase() + s.substring(1)).toString().replace(",", " ");

  if (poll_type == "numeric_scale") {
    editor.classList.add("hidden");
    document.getElementById("question-lbl").innerHTML = "Scale";
  } else {
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
      document.getElementById("comments-toggle-" + id).innerHTML = "Show Comments";
    }

    // Open the current dropdown
    comments.classList.remove("hidden")
    toggle.innerHTML = "Hide Comments"

  } else {
    comments.classList.add("hidden")
    toggle.innerHTML = "Show Comments"
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

function handle_tier_select(poll_id, tier) {

  if (document.activeElement.classList.contains("tier-answer")) {
    item = document.activeElement.parentNode;

    input = item.querySelector("input[name='answer_tier']");
    input.value = tier;

    container = document.getElementById(`${tier}-content-${poll_id}`);
    item.parentNode.removeChild(item);
    container.appendChild(item);
  } 

}
