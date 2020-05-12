import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { useSelector } from 'react-redux';

import { IRootStore } from '../../../shared/store';
import Button from '../../../components/Button';
import { ITheme } from '../../../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  wordDisplay: {
    margin: 'auto',
    padding: 24,
    backgroundColor: theme.palette.secondaryDark,
    borderRadius: 5,
  },
  bold: {
    color: theme.palette.primary,
    fontSize: 'bold',
  },
}));

interface IConfirmationProps {
  nextStage: () => void;
}

const Confirmation: React.FC<IConfirmationProps> = ({ nextStage }) => {
  const word = useSelector((store: IRootStore) => store.game.word);
  const classes = useStyle();

  const renderWord = () => {
    console.log(word);
    if (word === 'NONE') {
      return (
        <div>
          You don't know the word
          <br />
          <strong className={classes.bold}>Play It Cool</strong>
        </div>
      );
    } else {
      return (
        <div>
          The word is:
          <br />
          <strong>{word.toUpperCase()}</strong>
        </div>
      );
    }
  };

  return (
    <>
      <div className={classes.wordDisplay}>{renderWord()}</div>
      <Button label="Confirm" onClick={() => console.log('XD?')} />
    </>
  );
};

export default Confirmation;
