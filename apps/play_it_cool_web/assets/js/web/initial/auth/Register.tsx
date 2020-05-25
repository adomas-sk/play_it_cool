import React, { useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../../shared/theme';
import TextInput from '../../../components/TextInput';
import Button from '../../../components/Button';
import { useMutation } from '@apollo/react-hooks';
import { REGISTER } from '../queries';
import { REGISTER as REGISTER_ACTION } from '../actionTypes';
import { useDispatch } from 'react-redux';

const useStyle = makeStyles((theme: ITheme) => ({
  centerContent: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
}));

const Register = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [username, setUsername] = useState('');

  const classes = useStyle();
  const dispatch = useDispatch();
  const [register, { loading }] = useMutation(REGISTER, {
    onCompleted: (data) => dispatch({ type: REGISTER_ACTION, payload: data.register }),
  });

  const canRegister =
    password === passwordConfirmation && password.length > 5 && email.length > 5 && username.length > 5;

  return (
    <div className={classes.centerContent}>
      Register
      <TextInput label="Email" onChange={setEmail} />
      <TextInput
        label="Username"
        onChange={setUsername}
        message="Username has to be at least 6 characters long"
      />
      <TextInput
        password
        label="Password"
        onChange={setPassword}
        message="Password has to be at least 6 characters long"
      />
      <TextInput
        password
        label="Confirm password"
        onChange={setPasswordConfirmation}
        message="Confirm password has to be the same as Password"
      />
      <Button
        label="Register"
        loading={loading}
        disabled={!canRegister}
        onClick={() => register({ variables: { email, password, username } })}
      />
    </div>
  );
};

export default Register;
