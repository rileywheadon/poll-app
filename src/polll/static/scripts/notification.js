// Add a new event listener to handle the current page
function add_notification_listener() {
  document.body.addEventListener("notification", function(evt) { 
    notify(evt.detail.value)
  });
}


// Copy a link to the User's clipboard, then notify
function copy_link(url) {
  navigator.clipboard.writeText(url);
  notify("Link Copied!");
}


// Helper function for generating a notification
function notify(message) {

  // Get the notification wrapper
  wrapper = document.getElementById("notifications");

  // Create the notification div
  const notification = document.createElement("div");
  notification.className = "flex flex-row items-center py-2 w-48 mt-2 bg-nord-15/50 border-2 border-nord-15 rounded-md text-nord-0 dark:text-nord-4";
  notification.innerHTML = `<p class='mx-2'>${message}</p><button onclick='close_notification(this)' class='ml-auto mr-2'><i class='fa fa-close'></i></button>`;

  // Push the notification to the user, at the top of the notification queue
  wrapper.appendChild(notification);

  // After five seconds, remove the notification from the queue
  setTimeout(() => notification.remove(), 5000);

}

// Close notification
function close_notification(button) {
  button.parentNode.remove();
}
