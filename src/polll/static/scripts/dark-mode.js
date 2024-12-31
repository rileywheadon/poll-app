function update_icon() {
  const icon = document.getElementById("colour-icon");
  if (icon !== null) {
    if (localStorage.theme == "light") {
      icon.classList.remove("fa-sun");
      icon.classList.add("fa-moon");
    } else {
      icon.classList.remove("fa-moon");
      icon.classList.add("fa-sun");
    }
  }
}

function set_light_mode() {
  localStorage.theme = "light";
  document.body.classList.remove("dark");
  // Set light-mode icon
}

function set_dark_mode() {
  localStorage.theme = "dark";
  document.body.classList.add("dark");
  // Set dark-mode icon
}

function toggle_colour_scheme() {
  if (localStorage.theme == "dark") {
    set_light_mode();
  } else {
    set_dark_mode();
  }
  update_icon();
}

// Add event listeners to ensure correct theme
['load','htmx:afterSettle'].forEach( evt => 
  window.addEventListener(evt, function() {
    if (localStorage.theme === null) {
      set_dark_mode();
    } else if (localStorage.theme == "dark") {
      set_dark_mode();
    } else {
      set_light_mode();
    }
    update_icon();
  })
);

