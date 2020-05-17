import React from 'react';
import { makeStyles } from '@material-ui/styles';
import clsx from 'clsx';
import { ITheme } from '../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  container: {
    padding: 4,
  },
  buttonBase: {
    padding: '16px 34px',
    fontSize: 24,
    color: theme.palette.secondary,
    border: 'none',
    borderRadius: 4,
  },
  button: {
    background: theme.palette.primary,
    transition: 'top 0.15s',
    boxShadow: '0px 5px 5px 0px rgba(0,0,0,0.5)',
    cursor: 'pointer',

    '&:hover': {
      background: theme.palette.primaryLight,
      transform: 'translateY(2px)',
      boxShadow: '0px 3px 5px 0px rgba(0,0,0,0.3)',
    },
  },
  disabled: {
    background: theme.palette.primaryLight,
  },
  fullWidth: {
    width: '100%',
  },
}));

interface IButtonProps {
  label: string | number;
  onClick?: (e?: React.MouseEvent) => void;
  disabled?: boolean;
  fullWidth?: boolean;
  loading?: boolean;
}

const Button: React.FC<IButtonProps> = ({
  label,
  onClick,
  fullWidth,
  disabled = false,
  loading = false,
}) => {
  const classes = useStyle();

  const buttonClassName = clsx({
    [classes.buttonBase]: true,
    [classes.fullWidth]: fullWidth,
    [classes.disabled]: disabled,
    [classes.button]: !disabled,
  });

  return (
    <div className={classes.container}>
      <button
        type="button"
        className={buttonClassName}
        onClick={onClick}
        disabled={disabled || loading}
      >
        {label}
        {loading ? '...' : ''}
      </button>
    </div>
  );
};

export default Button;
