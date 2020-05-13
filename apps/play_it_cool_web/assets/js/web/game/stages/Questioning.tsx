import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { IRootStore } from '../../../shared/store';
import Button from '../../../components/Button';
import { markQuestionAsAnswered } from '../actions';

interface IQuestioningProps {
  nextStage: () => void;
}

const Questioning: React.FC<IQuestioningProps> = ({ nextStage }) => {
  const questioneer = useSelector(
    (store: IRootStore) => store.game.questioneer
  );
  const answereer = useSelector((store: IRootStore) => store.game.answereer);
  const question = useSelector((store: IRootStore) => store.game.question);
  const votingStarted = useSelector(
    (store: IRootStore) => store.game.votingStarted
  );
  const dispatch = useDispatch();

  useEffect(() => {
    if (votingStarted) {
      nextStage();
    }
  }, [votingStarted]);

  const showQuestioningBoard = () => {
    const currentUsername = localStorage.getItem('currentUsername');
    if (currentUsername == questioneer?.name && question && answereer) {
      return (
        <div>
          You're asking {answereer.name}!<br /> Question: <br />
          <strong>{question.question}</strong>
          <Button
            label="Mark as Answered"
            onClick={() => dispatch(markQuestionAsAnswered(question.id))}
          />
        </div>
      );
    }
    if (questioneer && answereer) {
      return (
        <div>
          {questioneer.name} is asking {answereer.name}
        </div>
      );
    }
    return <div>Loading...</div>;
  };

  return (
    <div>
      We are questioning stuff
      {showQuestioningBoard()}
    </div>
  );
};

export default Questioning;
