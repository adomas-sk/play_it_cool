import React, { useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  helperContainer: {
    position: 'fixed',
    left: 16,
    bottom: 16,
    zIndex: 10,
    padding: 16,
    borderRadius: '50%',
    cursor: 'pointer',

    '&:hover': {
      background: theme.palette.tint,
    },

    '@media screen and (max-width: 800px)': {
      height: 32,
      width: 32,
      padding: 8,
    },
  },

  helperText: {
    position: 'fixed',
    left: 16,
    bottom: 128,
    backgroundColor: theme.palette.tint,
    zIndex: 10,
    borderRadius: 5,
    padding: 16,
    fontSize: 14,
    maxWidth: 250,

    '& ol': {
      paddingLeft: 16,
    },

    '& h3': {
      fontSize: 18,
      margin: 0,
      marginBottom: 12,
    },
    '& h4': {
      fontSize: 16,
      margin: 0,
      marginBottom: 12,
    },

    '@media screen and (max-width: 800px)': {
      fontSize: 12,
      bottom: 64,
    },
  },
  hidden: {
    display: 'none',
  },
}));

const Helper: React.FC = () => {
  const classes = useStyle();
  const [open, setOpen] = useState(false);

  return (
    <>
      <img onClick={() => setOpen(!open)} className={classes.helperContainer} src="/images/icons/help.svg" />
      <div className={open ? classes.helperText : classes.hidden}>
        <h3>Help</h3>
        <h4>How to play:</h4>
        <ol>
          <li>A registered player creates lobby</li>
          <li>Player who created the lobby can invite other players by sharing lobby token</li>
          <li>Player who created the lobby can start a game by choosing a topic</li>
          <li>When game is started all players except one gets the word</li>
          <li>Player ask each other questions they are given (or can make up their own, I can't stop you)</li>
          <li>
            When all questions are asked, players vote who they thought didn't know the word (the player who
            didn't know the word guesses what the word was)
          </li>
          <li>
            When all players vote, the game is concluded and results are shown. Player who created the lobby
            can start a new game
          </li>
        </ol>
      </div>
    </>
  );
};

export default Helper;
