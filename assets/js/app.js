import "phoenix_html";
import "bootstrap";
import React from 'react';
import ReactDOM from 'react-dom';

import socket from "./socket";

import ApiClient from "./api-client";

function ready(channel, state) {
  let root = document.getElementById('root');
  ReactDOM.render(<ApiClient state={state} channel={channel} />, root);
}

function start() {
  let channel = socket.channel("api:", {});
  channel.join()
	  .receive("ok", state0 => {
		  console.log("Joined successfully", state0);
		  ready(channel, state0);
	  })
	  .receive("error", resp => {
		  console.log("Unable to join", resp);
	  });
}

$(document).ready(function() {
    start();
});