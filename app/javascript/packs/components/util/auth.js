import Vue from 'vue';

var user = null;
var session_token = null;

export default {
  // Retrieves session token
  get_session_token() {
    if (session_token == null)
      session_token = localStorage.token ? localStorage.token : null;
    return session_token;
  },
  // Retrieves user data
  get_user_object() {
    return new Promise((resolve, reject) => {
      if (user != null) {
        resolve(user);
      } else {
        if (this.get_session_token() == null) {
          user = null;
          resolve(null);
        }
        this.request('user/get')
          .then(result => {
            user = result.data.user;
            console.log(user);
            resolve(user);
          })
          .catch(error => {
            user = null;
            console.error(error.data);
            reject(error);
          });
      }
    });
  },
  // Starts session
  login(email, password, client) {
    return new Promise((resolve, reject) => {
      this.request('user/new_session', {
        email,
        password,
        client
      })
        .then(result => {
          session_token = result.data.session_key;
          localStorage.token = session_token;
          resolve(result);
        })
        .catch(error => {
          console.error('Error logging in');
          console.error(error);
          reject(error);
        });
    });
  },
  // Logs out locally
  logout() {
    return new Promise((resolve, reject) => {
      this.request('user/close_session', {
        session_key: this.get_session_token()
      })
        .then(result => {
          user = null;
          session_token = null;
          localStorage.token = null;
          resolve(result);
        })
        .catch(error => {
          console.error('Error logging out');
          console.error(error);
          reject(error);
        });
    });
  },
  // Sends POST request to API
  request(path, data) {
    if (!data) data = {};
    data.auth = { session_key: this.get_session_token() };
    return Vue.http.post(path, data);
  }
};
