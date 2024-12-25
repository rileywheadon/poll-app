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
}
