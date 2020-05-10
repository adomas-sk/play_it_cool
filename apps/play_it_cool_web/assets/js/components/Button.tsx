import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  container: {
    padding: 4,
    width: '100%',
  },
  button: {
    padding: '16px 34px',
    color: theme.palette.secondary,
    fontSize: 24,
    background: theme.palette.primary,
    transition: 'top 0.15s',
    border: 'none',
    borderRadius: 4,
    boxShadow: '0px 5px 5px 0px rgba(0,0,0,0.5)',

    '&:hover': {
      background: theme.palette.primaryLight,
      transform: 'translateY(2px)',
      boxShadow: '0px 3px 5px 0px rgba(0,0,0,0.5)',
    },
  },
}));

interface IButtonProps {
  label: string;
  onClick: (e?: React.MouseEvent) => void;
}

const Button: React.FC<IButtonProps> = ({ label, onClick }) => {
  const classes = useStyle();

  return (
    <div className={classes.container}>
      <button type="button" className={classes.button} onClick={onClick}>
        {label}
      </button>
    </div>
  );
};

export default Button;
