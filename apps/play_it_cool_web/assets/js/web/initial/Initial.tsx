import React, { useState, useEffect } from 'react';
import Button from '../../components/Button';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../shared/theme';
import { useHistory } from 'react-router-dom';
import { useMutation } from '@apollo/react-hooks';
import { LOGIN } from './queries';
import { useDispatch } from 'react-redux';
import { loginAction } from './actions';
import Login from './auth/Login';
import Register from './auth/Register';

const useStyle = makeStyles((theme: ITheme) => ({
  divider: {
    height: 1,
    width: '100%',
    margin: 24,
    backgroundColor: theme.palette.secondaryDark,
  },
  centerContent: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  auth: {
    display: 'flex',
    alignItems: 'center',

    '@media screen and (max-width: 800px)': {
      flexDirection: 'column',
    },
  },
  dividerHorizontal: {
    margin: 12,
    height: '100%',
    width: 1,
    backgroundColor: theme.palette.secondaryDark,

    '@media screen and (max-width: 800px)': {
      width: '100%',
      height: 1,
    },
  },
}));

const Initial = () => {
  const classes = useStyle();
  const history = useHistory();

  useEffect(() => {
    if (localStorage.getItem('loginToken')) {
      history.push('/lobby');
    }
  }, []);

  return (
    <>
      <div className={classes.auth}>
        <Login />
        <div className={classes.dividerHorizontal} />
        <Register />
      </div>
      <div className={classes.divider} />
      <div className={classes.centerContent}>
        Or continue as a guest
        <Button label="Continue" onClick={() => history.push('/lobby')} />
      </div>
    </>
  );
};

export default Initial;
