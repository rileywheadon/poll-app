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

function update_poll_editor(pressed_id) {
  const answers = document.getElementById("ans-types");
  answers.classList.remove("hidden");
  pressed_id == "scale-btn" ? answers.classList.add("hidden") : answers.classList.remove("hidden");
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

// TODO: call update_poll_editor based on id (might be better to re-write it )
function adjust_button_icons(pressed_id) {
  const buttons = [document.getElementById("choose-one-btn"),
                   document.getElementById("choose-many-btn"),
                   document.getElementById("scale-btn"),
                   document.getElementById("ranking-btn"),
                   document.getElementById("tier-list-btn")];
  buttons.forEach((b) => {
    b.classList.remove("border-4");
    b.classList.remove("border-emerald-800");

    b.classList.remove("border-8");
    b.classList.remove("border-blue-600");

    if (b.id == pressed_id) {
      b.classList.add("border-4");
      b.classList.add("border-blue-600");
      update_poll_editor(pressed_id)
    } else {
      b.classList.add("border-4");
      b.classList.add("border-emerald-800");
    }
  });

}

// TODO: figure out how to condition on the number of questions
function show_remove_button() {
  true ? document.getElementById("remove-ans-btn").classList.remove("hidden") : document.getElementById("remove-ans-btn").classList.add("hidden");
}