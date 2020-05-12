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
  input: {
    border: 'none',
    borderRadius: 4,
    height: 50,
    width: '100%',
    fontSize: 24,
    fontFamily: "'Balsamiq Sans', 'Helvetica', 'Arial', sans-serif",
  },
  label: {
    fontSize: 16,
    color: theme.palette.primary,
  },
}));

interface ITextInputProps {
  label: string;
  outerValue?: string;
  onChange?: (v: string) => void;
}

const TextInput: React.FC<ITextInputProps> = ({
  label,
  outerValue,
  onChange,
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
      <div className={classes.label}>{label}</div>
      <input
        className={classes.input}
        type="text"
        value={usedValue}
        onChange={(e) => onChangeCallback(e.target.value)}
      />
    </div>
  );
};

export default TextInput;
