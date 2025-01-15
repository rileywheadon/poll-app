// TODO: update graphs + everything else built specifically for dark mode
function update_icons() {

  const themeIcon = document.getElementById("theme-icon");
  const themeText = document.getElementById("theme-text");
  
  [
    document.getElementById("logo-icon-startup"), 
    document.getElementById("logo-icon-home")
  ].forEach(icon => {
    if (icon) {
      path = "../static/assets/logo-name-" + localStorage.theme.toString() + ".svg"
      icon.setAttribute("src", path)
    }
  });

  if (themeIcon) {
    if (localStorage.theme == "light") {
      themeIcon.classList.remove("fa-sun");
      themeIcon.classList.add("fa-moon");
      themeText.innerHTML = "Dark";
    } else {
      themeIcon.classList.remove("fa-moon");
      themeIcon.classList.add("fa-sun");
      themeText.innerHTML = "Light";
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
  update_icons();
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
    update_icons();
  })
);

