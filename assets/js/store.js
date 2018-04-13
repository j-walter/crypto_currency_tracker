// followed nat's lecture notes to learn about redux
import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';

function cryptos(state = [], action) {
  switch (action.type) {
  case 'CRYPTOS_LIST':
    return [...action.cryptos];
  case 'ADD_CRYPTO':
    return [action.crypto, ...state];
  default:
    return state;
  }
}

function users(state = [], action) {
  switch (action.type) {
  case 'USERS_LIST':
    return [...action.users];
  default:
    return state;
  }
}

// let empty_form = {
//   user_id: "",
//   title: "",
//   descrip: "",
//   work_time: 0,
//   complete: false,
//   token: "",
// };

// function form(state = empty_form, action) {
//   switch (action.type) {
//     case 'UPDATE_FORM':
//       return Object.assign({}, state, action.data);
//     case 'CLEAR_FORM':
//       return empty_form;
//     case 'SET_TOKEN':
//       return Object.assign({}, state, action.token);
//     case 'SET_TIME':
//       return Object.assign({}, state, action.data);
//     default:
//       return state;
//   }
// }

// we will need to add a token somewhere during login 
function token(state = null, action) {
  switch (action.type) {
    // case 'SET_TOKEN':
    //   return action.token;
    case 'GET_TOKEN':
      return state;
    default:
      return state;
  }
}

// function google_login(state = , action) {
//   switch (action.type) {
//     case 'UPDATE_LOGIN_FORM':
//       return Object.assign({}, state, action.data);
//     default:
//       return state;
//   }
// }

function root_reducer(state0, action) {
  console.log("reducer", action);
  let reducer = combineReducers({cryptos, token,});
  let state1 = reducer(state0, action);
  console.log("state1", state1);
  return deepFreeze(state1);
}

let store = createStore(root_reducer);
export default store;