import React, { useEffect, useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import { useSelector, useDispatch } from 'react-redux';

import { IRootStore } from '../../../shared/store';
import Button from '../../../components/Button';
import { ITheme } from '../../../shared/theme';
import { confirmWord } from '../actions';

const useStyle = makeStyles((theme: ITheme) => ({
  wordDisplay: {
    margin: 'auto',
    padding: 24,
    backgroundColor: theme.palette.secondaryTint,
    borderRadius: 5,
    boxShadow: `0px 0px 10px 3px ${theme.palette.tint}`,
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
  const [confirmed, setConfirmed] = useState(false);
  const word = useSelector((store: IRootStore) => store.game.word);
  const questioneer = useSelector(
    (store: IRootStore) => store.game.questioneer
  );
  const classes = useStyle();
  const dispatch = useDispatch();

  useEffect(() => {
    if (questioneer) {
      nextStage();
    }
  }, [questioneer]);

  const renderWord = () => {
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
          You know the word! The word is:
          <br />
          <strong className={classes.bold}>{word.toUpperCase()}</strong>
        </div>
      );
    }
  };

  return (
    <>
      <div className={classes.wordDisplay}>{renderWord()}</div>
      {confirmed ? (
        <Button label="Waiting for other players..." disabled />
      ) : (
        <Button
          label="Confirm"
          onClick={() => {
            dispatch(confirmWord());
            setConfirmed(true);
          }}
        />
      )}
    </>
  );
};

export default Confirmation;
