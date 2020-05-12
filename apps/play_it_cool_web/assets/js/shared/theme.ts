type Color = string;

export interface ITheme {
  palette: {
    primary: Color;
    primaryLight: Color;
    secondary: Color;
    secondaryDark: Color;
    green: Color;
    red: Color;
    black: Color;
    white: Color;
    secondaryTint: Color;
    tint: Color;
  };
  sizes: {
    footerHeight: number;
    contentBackgroundSpacing: number;
  };
}

const theme: ITheme = {
  palette: {
    primary: '#FFF643',
    primaryLight: '#FFF864',
    secondary: '#662E9B',
    secondaryDark: '#50247a',
    green: '#71e284',
    red: '#e03c5a',
    black: '#030303',
    white: '#FEFEFF',
    secondaryTint: 'rgba(80 , 36, 122, 0.4)',
    tint: 'rgba(0, 0, 0, 0.4)',
  },
  sizes: {
    footerHeight: 64,
    contentBackgroundSpacing: 24,
  },
};

export default theme;
