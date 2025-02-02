// annoyed so did this
['load', 'htmx:afterSettle'].forEach( evt => 
  window.addEventListener(evt, function() {
  
    document.getElementById("multiple-ans").querySelectorAll("input").forEach((textBox) => {
      textBox.addEventListener("keypress", (kp) => {
        if (kp["key"] == "Enter") document.getElementById("answer-add").click();
      });
    });

  })
);

function open_settings() {
  const main = document.getElementById("main");
  main.classList.add("blur-sm");
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
  var endpoint_editor = document.getElementById("endpoint-container");

  // Hack
  document.getElementById("question-lbl").innerHTML = poll_type.split("_").map((s) => s[0].toUpperCase() + s.substring(1)).toString().replace(",", " ");

  if (poll_type == "numeric_scale") {
    endpoint_editor.classList.remove("hidden");
    editor.classList.add("hidden");
    document.getElementById("question-lbl").innerHTML = "Scale";
  } else {
    endpoint_editor.classList.add("hidden");
    editor.classList.remove("hidden");
  }

}

function toggle_comments(poll_id) {
  comments = document.getElementById("poll-comments-" + poll_id);
  toggle = document.getElementById("comments-toggle-" + poll_id);

  if (toggle.innerHTML == "Show Comments") {
    toggle.innerHTML = "Hide Comments"
  } else {
    toggle.innerHTML = "Show Comments"
  }

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

function toggle_filter_time_dropdown() {
  document.getElementById("filter-time-dropdown").classList.toggle("hidden");
}

function handle_tier_select(poll_id, tier) {

  if (document.activeElement.classList.contains("tier-answer")) {
    item = document.activeElement.parentNode;

    input = item.querySelector("input[name='answer_tier']");
    input.value = tier;
    
    container = document.getElementById(`${tier}-content-${poll_id}`);
    item.parentNode.removeChild(item);
    container.appendChild(item);
  } 

}

function toggle_custom_endpoints() {
  document.getElementById("endpoint-editor").classList.toggle("hidden");
  document.getElementById("endpoint-left").value = "";
  document.getElementById("endpoint-right").value = "";
}

// TODO: Discuss in what format the data will be submitted and assign values to inputs accordingly
function handle_rank_select(poll_id, ans_id) {

  var opts = document.getElementById(`ans-container-${poll_id}`).querySelectorAll("input");
  var rs = document.getElementById(`checkbox-${ans_id}`);

  // count how many check box items are clicked AFTER the one that called this function was clicked
  var checkCount = Array.from(opts).map((b) => b.checked ? 1 : 0).reduce((acc, curr) => acc + curr);

  document.getElementById(`rank-num-${ans_id}`).innerHTML = checkCount.toString();
  document.getElementById(`rank-num-${ans_id}`).classList.remove("hidden");

  document.getElementById(`rank-input-${ans_id}`).value = checkCount.toString();

  // Ensure the button cannot be clicked again
  rs.disabled = true;

}

function clear_ranking(poll_id) {
  document.getElementById(`ans-container-${ poll_id }`).querySelectorAll("input").forEach((e) => {

    if (e.checked) {
      // remove the ranking text from the label
      var ans_id = e.parentNode.querySelector("input").id.toString();
      var ans_id_num = ans_id.substring(ans_id.indexOf("-") + 1);
      document.getElementById(`rank-num-${ans_id_num}`).classList.add("hidden");
      document.getElementById(`rank-num-${ans_id_num}`).innerHTML = "";
      document.getElementById(`rank-input-${ans_id_num}`).value = "";
    }
    // reset to default behaviour
    e.checked = false;
    e.disabled = false;
  })
}

function loading(url, parent_div) {
  
  // Create the icon (if you want text then you have to make a parent div and only make the fa icon spin)
  var loading_div = document.createElement("div");
  loading_div.classList.add("flex");
  loading_div.classList.add("flex-col");
  loading_div.classList.add("grow");
  loading_div.classList.add("justify-center");
  loading_div.classList.add("items-center");
  loading_div.classList.add("size-fit");
  loading_div.classList.add("animate-spin");  
  loading_div.innerHTML = '<i class="fa-solid fa-spinner text-base md:text-2xl text-polll-green p-4"></i>'
  
  // Replace the current main content body with the loading div
  document.getElementById(parent_div).replaceWith(loading_div)
  
  // go to the url that was pressed
  window.location.href = url;

}