import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';
import clsx from 'clsx';

const useStyle = makeStyles((theme: ITheme) => ({
  '@keyframes move-down': {
    '0%': {
      transform: 'translateY(0px)',
    },
    '100%': {
      transform: 'translateY(160px)',
    },
  },
  '@keyframes move-right': {
    '0%': {
      transform: 'translate3d(0px, 0px, 0px)',
    },
    '100%': {
      transform: 'translate3d(160px, 0px, 0px)',
    },
  },
  container: {
    position: 'fixed',
    zIndex: 2,
    width: 'calc(100% + (64px + 64px + 96px + 96px))',
    height: 'calc(100% + (64px + 64px + 96px + 96px))',
    display: 'flex',
    top: -(64 + 96),
    left: -(64 + 96),
  },
  moveDownAnimation: {
    animationTimingFunction: 'linear',
    animation: '$move-down 5s infinite',
  },
  moveRightAnimation: {
    animationTimingFunction: 'linear',
    animation: '$move-right 5s infinite steps(160)',
  },
  icon: {
    height: 64,
    width: 64,
    padding: 48,
    margin: 0,
    opacity: 0.6,

    '& path': {
      color: 'white',
    },
  },
}));

const icons: { [key: string]: string } = {
  baseball: '/images/icons/baseball.svg',
  basketball: '/images/icons/basketball.svg',
  building: '/images/icons/building.svg',
  burger: '/images/icons/burger.svg',
  cassette: '/images/icons/cassette.svg',
  cat: '/images/icons/cat.svg',
  champagne: '/images/icons/champagne.svg',
  city: '/images/icons/city.svg',
  cycling: '/images/icons/cycling.svg',
  cyclops: '/images/icons/cyclops.svg',
  dj: '/images/icons/dj.svg',
  dog: '/images/icons/dog.svg',
  drink: '/images/icons/drink.svg',
  fake_football: '/images/icons/fake_football.svg',
  guitar: '/images/icons/guitar.svg',
  heart_hands: '/images/icons/heart_hands.svg',
  message: '/images/icons/message.svg',
  mouse: '/images/icons/mouse.svg',
  phone: '/images/icons/phone.svg',
  piano: '/images/icons/piano.svg',
};

const IconAnimation: React.FC = () => {
  const classes = useStyle();
  const isAnimationDown = Math.random() >= 0.5;
  const iconClassName = clsx({
    [classes.icon]: true,
    [classes.moveRightAnimation]: !isAnimationDown,
    [classes.moveDownAnimation]: isAnimationDown,
  });

  const height = window.innerHeight;
  const width = window.innerWidth;

  if (isAnimationDown) {
    return (
      <div className={classes.container} style={{ flexDirection: 'row' }}>
        {Array.from(Array(Math.floor(width / (64 + 94)) + 2)).map((_, heightIndex) => {
          const randomIndex = Math.floor(Math.random() * Object.keys(icons).length);
          const randomIcon = icons[Object.keys(icons)[randomIndex]];
          return (
            <div key={heightIndex} style={{ display: 'flex', flexDirection: 'column' }}>
              {Array.from(Array(Math.floor(height / (64 + 94)) + 2)).map((_, widthIndex) => (
                <img key={`${widthIndex} ${heightIndex}`} src={randomIcon} className={iconClassName} />
              ))}
            </div>
          );
        })}
      </div>
    );
  }

  return (
    <div className={classes.container} style={{ flexDirection: 'column' }}>
      {Array.from(Array(Math.floor(height / (64 + 94)) + 2)).map((_, heightIndex) => {
        const randomIndex = Math.floor(Math.random() * Object.keys(icons).length);
        const randomIcon = icons[Object.keys(icons)[randomIndex]];
        return (
          <div key={heightIndex} style={{ height: 64 + 96 }}>
            {Array.from(Array(Math.floor(width / (64 + 94)) + 2)).map((_, widthIndex) => (
              <img key={`${widthIndex} ${heightIndex}`} src={randomIcon} className={iconClassName} />
            ))}
          </div>
        );
      })}
    </div>
  );
};

export default IconAnimation;
