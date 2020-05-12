import React, { ReactChildren, ReactChild } from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';
import Footer from './Footer';
import clsx from 'clsx';
import { useLocation } from 'react-router-dom';

const useStyle = makeStyles((theme: ITheme) => ({
  container: {
    width: '100%',
    minHeight: '100vh',
    backgroundColor: theme.palette.secondary,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  childrenContainer: {
    backgroundColor: theme.palette.tint,
    maxWidth: 1096,
    margin: theme.sizes.contentBackgroundSpacing,
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
    height: `calc(100vh - (${theme.sizes.footerHeight}px + ${
      theme.sizes.contentBackgroundSpacing * 4
    }px))`,
    borderRadius: 4,
    padding: theme.sizes.contentBackgroundSpacing,
  },
  introBackground: {
    // background: 'url("/images/space.gif")',
    background: 'url("/images/staticBackground.svg")',
    // background: 'url("/images/pattern.gif")',
    backgroundRepeat: 'no-repeat',
    backgroundSize: 'cover',
  },
  gameBackground: {
    background: 'url("/images/staticBackground.svg")',
    backgroundRepeat: 'no-repeat',
    backgroundSize: 'cover',
  },
}));

interface ILayoutProps {
  children: React.ReactNode;
}

const Layout: React.FC<ILayoutProps> = ({ children }) => {
  const classes = useStyle();
  const location = useLocation();

  const isIntroScreen = ['/lobby', '/'].includes(location.pathname);

  const containerClassName = clsx({
    [classes.container]: true,
    [classes.introBackground]: isIntroScreen,
    [classes.gameBackground]: !isIntroScreen,
  });

  return (
    <div className={containerClassName}>
      <div className={classes.childrenContainer}>{children}</div>
      <Footer />
    </div>
  );
};

export default Layout;
