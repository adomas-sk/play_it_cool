import React, { ReactChildren, ReactChild } from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';

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
    maxWidth: 1096,
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
  },
}));

interface ILayoutProps {
  children: ReactChildren | ReactChild;
}

const Layout: React.FC<ILayoutProps> = ({ children }) => {
  const classes = useStyle();

  return (
    <div className={classes.container}>
      <div className={classes.childrenContainer}>{children}</div>
    </div>
  );
};

export default Layout;
