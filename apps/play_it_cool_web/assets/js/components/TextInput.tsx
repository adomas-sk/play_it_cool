import React, { useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  inputContainer: {
    padding: 8,
    width: '100%',
    maxWidth: 400,
    margin: 4,
  },
  inputWrapper: {
    width: '100%',
    maxWidth: 400,
  },
  input: {
    border: 'none',
    borderRadius: 4,
    padding: '4px 12px',
    height: 50,
    width: '100%',
    fontSize: 24,
    fontFamily: "'Varela Round', 'Helvetica', 'Arial', sans-serif",
    color: theme.palette.secondaryDark,
    boxSizing: 'border-box',
  },
  label: {
    fontSize: 16,
    fontWeight: 'bold',
    color: theme.palette.primary,
  },
  message: {
    color: theme.palette.primaryLight,
    margin: 0,
    fontSize: 12,
  },
  tint: {
    background: theme.palette.tint,
    padding: '0 8px',
    display: 'inline-flex',
    flexDirection: 'column',
  },
}));

interface ITextInputProps {
  label: string;
  outerValue?: string;
  onChange?: (v: string) => void;
  password?: boolean;
  message?: string;
}

const TextInput: React.FC<ITextInputProps> = ({
  label,
  outerValue,
  onChange,
  message = '',
  password = false,
}) => {
  const classes = useStyle();
  const [value, setValue] = useState('');
  const shouldUseOuterValue = outerValue || outerValue;
  const onChangeCallback = onChange
    ? shouldUseOuterValue
      ? onChange
      : (val: string) => {
          onChange(val);
          setValue(val);
        }
    : setValue;
  const usedValue = shouldUseOuterValue === '' ? outerValue : value;
  return (
    <div className={classes.inputContainer}>
      <div className={classes.inputWrapper}>
        {message ? (
          <div className={classes.tint}>
            <label htmlFor={label} className={classes.label}>
              {label}
            </label>
            <p className={classes.message}>{message}</p>
          </div>
        ) : (
          <div className={classes.tint} style={{ marginBottom: 20 }}>
            <label htmlFor={label} className={classes.label}>
              {label}
            </label>
          </div>
        )}
        <input
          name={label}
          className={classes.input}
          type={password ? 'password' : 'text'}
          value={usedValue}
          onChange={(e) => onChangeCallback(e.target.value)}
        />
      </div>
    </div>
  );
};

export default TextInput;
