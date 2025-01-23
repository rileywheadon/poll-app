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

  editor = document.getElementById("answer-editor");

  document.getElementById("question-lbl").innerHTML = poll_type.split("_").map((s) => s[0].toUpperCase() + s.substring(1)).toString().replace(",", " ");

  if (poll_type == "numeric_scale") {
    editor.classList.add("hidden");
    document.getElementById("question-lbl").innerHTML = "Scale";
  } else {
    editor.classList.remove("hidden");
  }

}

function toggle_comments(poll_id) {
  comments = document.getElementById("poll-comments-" + poll_id);
  toggle = document.getElementById("comments-toggle-" + poll_id);
  document.getElementById("com-btn-txt").innerHTML == "Show Comments" ? document.getElementById("com-btn-txt").innerHTML = "Hide Comments" : document.getElementById("com-btn-txt").innerHTML = "Show Comments";
  comments.classList.toggle("hidden");
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

function toggle_filter_dropdown() {
  document.getElementById("filter-dropdown").classList.toggle("hidden");
}


function handle_btn_select() {

  console.log("Radio button clicked")

}



function handle_tier_select(poll_id, tier) {
  // This is being called twice and it's not because there are two buttons that call this function 
  // (removed the second button onclick and same thing happens)
  // might be happening because none of the radio buttons are clicked yet

  // Double 'click' is hapending when clicking on an element already in a tier

  console.log("new");
  document.getElementById(`tier-ans-container-${poll_id}`).querySelectorAll("input").forEach((e) => {
    if (e.checked) document.getElementById(`${tier}-content-${poll_id}`).appendChild(e.parentNode);
    // console.log(e);
    e.checked = false;
  });

  ["S", "A", "B", "C", "D", "F"].forEach((t) =>  {
    if (document.getElementById(`${t}-content-${poll_id}`).childNodes.length > 1) {
      //console.log(`${e} tier`);
      Array.from(document.getElementById(`${t}-content-${poll_id}`).childNodes).slice(1).forEach((i) => {
        Array.from(i.querySelectorAll("input")).forEach((j) => {
          //console.log(j);
          console.log(j.checked)
          if (j.checked) {
            document.getElementById(`${tier}-content-${poll_id}`).appendChild(i); 
          } 
        })
      })
    }    
  })


  console.log("\n\n\n");
  

}