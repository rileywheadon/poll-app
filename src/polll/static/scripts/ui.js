function open_settings() {
  const modal = document.getElementById("settings");
  const main = document.getElementById("main");
  modal.style.display = "flex";
  main.classList.add("blur-sm");
}

function close_settings() {
  const modal = document.getElementById("settings");
  const main = document.getElementById("main");
  modal.style.display = "none";
  main.classList.remove("blur-sm");
}

function toggle_user_information(user_id) {
  const info = document.getElementById("user-info-" + user_id)
  const toggle = document.getElementById("user-toggle-" + user_id)
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
  console.log(button);
  answer_list = document.getElementById("answer-list");

  if (answer_list.childElementCount > 2) {
    button.parentNode.remove(); 
  } else {
    notify("Polls require at least two answers!")
  }

}

function reset_poll_cooldown(user_id) {
  const cooldown = document.getElementById("user-cooldown-" + user_id);
  cooldown.innerHTML = "False";
}

function toggle_poll_information(poll_id) {
  const info = document.getElementById("poll-info-" + poll_id)
  const toggle = document.getElementById("poll-toggle-" + poll_id)
  info.classList.toggle("hidden")

  if (toggle.classList.contains("fa-angle-right")) {
    toggle.classList.remove("fa-angle-right");
    toggle.classList.add("fa-angle-down");
  } else {
    toggle.classList.remove("fa-angle-down");
    toggle.classList.add("fa-angle-right");
  }
}

function update_answer_editor(poll_type) {
  editor = document.getElementById("answer-editor")
  if (poll_type == "numeric_scale") {
    editor.classList.add("hidden");
  } else {
    editor.classList.remove("hidden");
  }
}

function toggle_graph(poll_id) {
  graph = document.getElementById("poll-graph-" + poll_id);
  toggle = document.getElementById("graph-toggle-" + poll_id);

  graph.classList.toggle("hidden");
  if (graph.classList.contains("hidden")) {
    toggle.innerHTML = "Show Results";
  } else {
    toggle.innerHTML = "Hide Results";
  }
}

function toggle_comments(poll_id) {
  comments = document.getElementById("poll-comments-" + poll_id);
  toggle = document.getElementById("comments-toggle-" + poll_id);

  comments.classList.toggle("hidden");
  if (comments.classList.contains("hidden")) {
    toggle.innerHTML = "Show Comments";
  } else {
    toggle.innerHTML = "Hide Comments";
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

  reply_list.classList.toggle("hidden");
  if (reply_list.classList.contains("hidden")) {
    reply_icon.classList.remove("fa-angle-down");
    reply_icon.classList.add("fa-angle-right");
  } else {
    reply_icon.classList.remove("fa-angle-right");
    reply_icon.classList.add("fa-angle-down");
  }

}
