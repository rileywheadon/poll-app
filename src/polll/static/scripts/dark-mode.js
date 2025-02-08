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

    const themes = localStorage.theme.toString();
    const icons = {
    "logo-choose-one": `../static/assets/choose-one-${themes}.png`,
    "logo-choose-many": `../static/assets/choose-many-${themes}.png`,
    "logo-scale": `../static/assets/scale-${themes}.png`,
    "logo-ranking": `../static/assets/ranking-${themes}.png`,
    "logo-tier-list": `../static/assets/tier-list-${themes}.png`
    };

    Object.entries(icons).forEach(([id, path]) => {
        const icon = document.getElementById(id);
        if (icon) {
            icon.setAttribute("src", path);
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
}

function set_dark_mode() {
  localStorage.theme = "dark";
  document.body.classList.add("dark");
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
    if (typeof localStorage.theme == "undefined" || localStorage.theme == null) {
      set_dark_mode();
    } else if (localStorage.theme == "dark") {
      set_dark_mode();
    } else {
      set_light_mode();
    }
    update_icons();
  })
);

