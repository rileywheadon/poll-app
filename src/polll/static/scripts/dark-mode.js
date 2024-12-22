function updateIcon() {
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

function setLightMode() {
  localStorage.theme = "light";
  document.body.classList.remove("dark");
}

function setDarkMode() {
  localStorage.theme = "dark";
  document.body.classList.add("dark");
}

function toggleColourScheme() {
  if (localStorage.theme == "dark") {
    setLightMode();
  } else {
    setDarkMode();
  }
  updateIcon();
}

window.addEventListener("load", function() {
  if (localStorage.theme === null) {
    setDarkMode();
  } else if (localStorage.theme == "dark") {
    setDarkMode();
  } else {
    setLightMode();
  }
  updateIcon();
})
