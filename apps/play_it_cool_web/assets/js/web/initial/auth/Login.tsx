import React, { useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../../shared/theme';
import TextInput from '../../../components/TextInput';
import Button from '../../../components/Button';
import { useMutation } from '@apollo/react-hooks';
import { LOGIN } from '../queries';
import { loginAction } from '../actions';
import { useDispatch } from 'react-redux';
import { useHistory } from 'react-router-dom';

const useStyle = makeStyles((theme: ITheme) => ({
  centerContent: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
}));

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const classes = useStyle();
  const dispatch = useDispatch();
  const history = useHistory();
  const [login, { loading }] = useMutation(LOGIN, {
    onCompleted: (data) => dispatch(loginAction(data, history)),
  });

  const canLogin = email.length > 5 && password.length > 5;

  return (
    <div className={classes.centerContent}>
      Login
      <TextInput label="Email" onChange={setEmail} />
      <TextInput password label="Password" onChange={setPassword} />
      <Button
        label="Login"
        disabled={!canLogin}
        loading={loading}
        onClick={() => login({ variables: { email, password } })}
      />
    </div>
  );
};

export default Login;
