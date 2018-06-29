import Vue from 'vue';

var user = null;
var session_token = null;

export default {
  // Retrieves session token
  get_session_token() {
    if (!session_token)
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
        this.request('user/fetch')
          .then(result => {
            user = result.data.user;
            resolve(user);
          })
          .catch(error => {
            user = null;
            if (error == 404) {
              user = null;
              session_token = null;
              localStorage.removeItem('token');
            }
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
          localStorage.removeItem('token');
          resolve(result);
        })
        .catch(error => {
          reject(error);
        });
    });
  },
  // Sends POST request to API
  request(path, data) {
    if (!data) data = {};
    let session_key = this.get_session_token();
    if (session_key) data.auth = { session_key };
    console.log(`requested ${path}: `);
    console.log(data);
    return Vue.http.post(path, data);
  }
};
