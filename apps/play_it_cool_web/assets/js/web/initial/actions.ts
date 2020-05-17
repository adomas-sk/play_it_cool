import { Dispatch } from 'redux';
import { ILoginResponse, LOGIN } from './queries';
import { History } from 'history';

export const loginAction = (
  data: { login: ILoginResponse },
  history: History
) => (dispatch: Dispatch) => {
  localStorage.setItem('loginToken', data.login.token);
  if (data.login.user.username) {
    localStorage.setItem('currentUsername', data.login.user.username);
  }

  dispatch({
    type: LOGIN,
    payload: data.login.user,
  });

  history.push('/lobby');
};
