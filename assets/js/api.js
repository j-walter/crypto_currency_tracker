// followed from Nat Tuck's lecture notes 
import store from './store';

class TheServer {
  request_users() {
    $.ajax("/api/v1/users", {
      method: "get",
      dataType: "json",
      headers: this.get_headers(),
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'USERS_LIST',
          users: resp.data,
        });
      },
    });
  }

  submit_user(data) {
    console.log(data);
    $.ajax("/api/v1/auth", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",

      success: (resp) => {
        store.dispatch({
          type: 'ADD_USER',
          user: resp.data,
        });
        // this.submit_login(data);
      },
    });
  }

  get_headers() {
    return {
      "Authorization": this.get_token()
    };
  }

  get_token() {
    if (store.getState().token) {
      return store.getState().token.token;
    }
  }

  // followed Nat's notes for login
//   submit_login(data) {
//     $.ajax("/api/v1/token", {
//       method: "post",
//       dataType: "json",
//       contentType: "application/json; charset=UTF-8",
//       data: JSON.stringify(data),
//       success: (resp) => {
//         store.dispatch({
//           type: 'SET_TOKEN',
//           token: resp,
//         });
//       },
//     });

//   }
}

export default new TheServer();