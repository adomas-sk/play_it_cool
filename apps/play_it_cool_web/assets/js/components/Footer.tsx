import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  footer: {
    height: theme.sizes.footerHeight,
    backgroundColor: theme.palette.tint,
    width: '100%',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    fontSize: 16,
    color: theme.palette.white,
  },
}));

const Footer = () => {
  const classes = useStyle();
  return <footer className={classes.footer}>All rights reserved ⓒ 2020</footer>;
};

export default Footer;
