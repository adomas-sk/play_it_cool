import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';
import Button from './Button';

const useStyle = makeStyles((theme: ITheme) => ({
  listContainer: {
    height: '100%',
    width: '100%',
    maxWidth: 600,
    display: 'flex',
    flexDirection: 'column',
  },
  listItem: {
    padding: 8,
    borderRadius: 4,
    width: '100%',
    background: theme.palette.secondaryTint,
    marginBottom: 8,
    display: 'flex',
    justifyContent: 'space-between',
    boxShadow: `0px 0px 10px 3px ${theme.palette.tint}`,

    '&:hover': {
      color: theme.palette.primary,
    },
  },
}));

type Item = {
  label: string | number;
  right?: string | number;
  key: string | number;
  onClick?: () => void;
};

interface IListProps {
  itemList?: Item[];
  loading: boolean;
  buttons?: boolean;
}

const List: React.FC<IListProps> = ({ itemList = [], loading, buttons }) => {
  const classes = useStyle();
  if (loading) {
    return (
      <div className={classes.listContainer}>
        <div className={classes.listItem}>Loading...</div>
      </div>
    );
  }
  if (buttons) {
    return (
      <div className={classes.listContainer}>
        {itemList.map((item) => (
          <Button
            label={item.label}
            fullWidth
            onClick={
              item.onClick ||
              (() => console.error('No onClick passed to List', { itemList }))
            }
            key={item.key}
          />
        ))}
      </div>
    );
  }
  return (
    <div className={classes.listContainer}>
      {itemList.map((item) => (
        <div className={classes.listItem} key={item.key}>
          <div>{item.label}</div>
          <div>{item.right}</div>
        </div>
      ))}
    </div>
  );
};

export default List;
