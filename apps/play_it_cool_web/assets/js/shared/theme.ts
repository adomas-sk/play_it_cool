type Color = string;

export interface ITheme {
  palette: {
    primary: Color;
    primaryLight: Color;
    secondary: Color;
    secondaryDark: Color;
    blue: Color;
    red: Color;
    black: Color;
    white: Color;
    secondaryTint: Color;
    tint: Color;
    lightTint: Color;
  };
  sizes: {
    footerHeight: number;
    contentBackgroundSpacing: number;
  };
}

const theme: ITheme = {
  palette: {
    primary: '#fc466b',
    primaryLight: '#fc8099',
    secondary: '#633A96',
    secondaryDark: '#4f2e77',
    blue: '#3f5efb',
    red: '#e03c5a',
    black: '#030303',
    white: '#FEFEFF',
    secondaryTint: 'rgba(80 , 36, 122, 0.8)',
    tint: 'rgba(0, 0, 0, 0.5)',
    lightTint: 'rgba(255, 255, 255, 0.5)',
  },
  sizes: {
    footerHeight: 64,
    contentBackgroundSpacing: 24,
  },
};

export default theme;
