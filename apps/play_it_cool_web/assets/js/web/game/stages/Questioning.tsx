import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { IRootStore } from '../../../shared/store';
import Button from '../../../components/Button';
import { markQuestionAsAnswered } from '../actions';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  question: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    padding: 24,
    margin: '24px auto',
    backgroundColor: theme.palette.secondaryTint,
    borderRadius: 4,

    '@media screen and (max-width: 800px)': {
      fontSize: '1rem',
    },

    '& strong': {
      color: theme.palette.primary,
    },
  },
}));

interface IQuestioningProps {
  nextStage: () => void;
}

const Questioning: React.FC<IQuestioningProps> = ({ nextStage }) => {
  const questioneer = useSelector((store: IRootStore) => store.game.questioneer);
  const answereer = useSelector((store: IRootStore) => store.game.answereer);
  const question = useSelector((store: IRootStore) => store.game.question);
  const votingStarted = useSelector((store: IRootStore) => store.game.votingStarted);
  const dispatch = useDispatch();

  const classes = useStyle();

  useEffect(() => {
    if (votingStarted) {
      nextStage();
    }
  }, [votingStarted]);

  const currentUsername = localStorage.getItem('currentUsername');
  if (currentUsername == questioneer?.name && question && answereer) {
    return (
      <>
        <div className={classes.question}>
          You're asking {answereer.name}!
          <br />
          <strong>{question.question}</strong>
        </div>
        <Button label="Mark as Answered" onClick={() => dispatch(markQuestionAsAnswered(question.id))} />
      </>
    );
  }
  if (questioneer && answereer) {
    return (
      <div className={classes.question}>
        {questioneer.name} is asking {answereer.name}
      </div>
    );
  }
  return <div>Loading...</div>;
};

export default Questioning;
