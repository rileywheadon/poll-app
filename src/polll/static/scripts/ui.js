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

function toggle_filter_button(col, id) {
    const buttons = [document.getElementById("New"),
                     document.getElementById("Hot"),
                     document.getElementById("Top")];
    buttons.forEach((b) => {
        b.classList.remove("bg-nord-9");
        b.classList.remove("dark:bg-nord-7");
        b.classList.add("bg-nord-4");
        b.classList.remove("font-semibold");
        b.classList.add("font-light");
        });
    document.getElementById(id).classList.add("bg-nord-9");
    document.getElementById(id).classList.add("dark:bg-nord-7");
    document.getElementById(id).classList.remove("font-light");
    document.getElementById(id).classList.add("font-semibold");
    // Could put callback function here for the each button based on its id
}


function update_answer_editor(poll_type) {
  editor = document.getElementById("answer-editor")
  if (poll_type == "numeric_scale") {
    editor.classList.add("hidden");
  } else {
    editor.classList.remove("hidden");
  }
}

