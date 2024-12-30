function open_settings() {
  const modal = document.getElementById("settings");
  modal.style.display = "flex";
}

function close_settings() {
  const modal = document.getElementById("settings");
  modal.style.display = "none";
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

function update_poll_editor() {
  const poll_type = document.getElementById("poll-type-selector").value;
  const editor = document.getElementById("answer-editor");
  const add = document.getElementById("answer-add");

  if (poll_type == "NUMERIC_STAR" || poll_type == "NUMERIC_SCALE") {
    editor.classList.add("hidden");
    add.classList.add("hidden");
  } else {
    editor.classList.remove("hidden");
    add.classList.remove("hidden");
  }
}

function remove_poll_answer(button) {
  button.parentNode.remove(); 
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

function translate_home_sidebar() {
    document.getElementById("logo-sidebar").classList.toggle("-translate-x-full");
    document.getElementById("hmbr-btn").classList.toggle("translate-x-8");
}

