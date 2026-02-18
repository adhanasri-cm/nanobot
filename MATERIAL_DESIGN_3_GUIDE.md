# Material Design 3 Implementation Guide for Nanobot React Agent

This guide explains how the Nanobot React Agent uses Material Design 3 for all UI development.

**Reference**: [Material Design 3 - https://m3.material.io/](https://m3.material.io/)

---

## Overview

Material Design 3 is the latest design system from Google. It provides:
- Comprehensive color system with dynamic theming
- Unified typography scale
- Component library with consistent interaction patterns
- Accessibility built-in
- Modern elevation and motion guidelines

The agent uses Material Design 3 by default for all UI components.

---

## Color System

### Primary Colors

Material Design 3 uses a tonal system where each color has multiple shades:

```
Primary: #6750a4 (base color)
├── On Primary: #ffffff (text/icons on primary)
├── Primary Container: #eaddff
└── On Primary Container: #21005d
```

Similar hierarchies for:
- **Secondary**: Supporting color for secondary UI
- **Tertiary**: Accent color for highlights
- **Error**: For error states and warnings
- **Surface**: Background colors (Surface, Surface Variant)
- **Background**: Overall app background

### Dynamic Color (Optional)

Material Design 3 supports dynamic theming where colors are derived from the device's wallpaper. The agent respects this when available.

### Implementation in MUI

```tsx
import { createTheme, ThemeProvider } from '@mui/material/styles';
import { blue, purple } from '@mui/material/colors';

const theme = createTheme({
  palette: {
    primary: {
      main: '#6750a4',      // Primary color
      light: '#eaddff',     // Primary container
      dark: '#21005d',
      contrastText: '#ffffff', // On primary
    },
    secondary: {
      main: '#625b71',
      light: '#e8def8',
      dark: '#3e2723',
      contrastText: '#ffffff',
    },
    tertiary: {
      main: '#7d5260',
      light: '#ffd8e4',
      dark: '#370b1e',
      contrastText: '#ffffff',
    },
    error: {
      main: '#b3261e',
      light: '#f9dedc',
      dark: '#370b1e',
      contrastText: '#ffffff',
    },
    background: {
      default: '#fffbfe',   // Material 3 background
      paper: '#fffbfe',     // Material 3 surface
    },
  },
});

export function App() {
  return (
    <ThemeProvider theme={theme}>
      {/* Your app */}
    </ThemeProvider>
  );
}
```

---

## Typography

Material Design 3 defines a complete typography scale:

### Type Scale

| Scale | Size | Weight | Line Height | Letter Spacing |
|-------|------|--------|-------------|---|
| Display Large | 57px | 400 | 64px | -0.25px |
| Display Medium | 45px | 400 | 52px | 0px |
| Display Small | 36px | 400 | 44px | 0px |
| Headline Large | 32px | 400 | 40px | 0px |
| Headline Medium | 28px | 400 | 36px | 0px |
| Headline Small | 24px | 500 | 32px | 0px |
| Title Large | 22px | 500 | 28px | 0px |
| Title Medium | 16px | 500 | 24px | 0.15px |
| Title Small | 14px | 500 | 20px | 0.1px |
| Body Large | 16px | 400 | 24px | 0.5px |
| Body Medium | 14px | 400 | 20px | 0.25px |
| Body Small | 12px | 400 | 16px | 0.4px |
| Label Large | 14px | 500 | 20px | 0.1px |
| Label Medium | 12px | 500 | 16px | 0.5px |
| Label Small | 11px | 500 | 16px | 0.5px |

### In MUI

```tsx
const theme = createTheme({
  typography: {
    displayLarge: {
      fontSize: '57px',
      fontWeight: 400,
      lineHeight: '64px',
      letterSpacing: '-0.25px',
    },
    displayMedium: {
      fontSize: '45px',
      fontWeight: 400,
      lineHeight: '52px',
    },
    displaySmall: {
      fontSize: '36px',
      fontWeight: 400,
      lineHeight: '44px',
    },
    headlineLarge: {
      fontSize: '32px',
      fontWeight: 400,
      lineHeight: '40px',
    },
    headlineMedium: {
      fontSize: '28px',
      fontWeight: 400,
      lineHeight: '36px',
    },
    headlineSmall: {
      fontSize: '24px',
      fontWeight: 500,
      lineHeight: '32px',
    },
    titleLarge: {
      fontSize: '22px',
      fontWeight: 500,
      lineHeight: '28px',
    },
    titleMedium: {
      fontSize: '16px',
      fontWeight: 500,
      lineHeight: '24px',
      letterSpacing: '0.15px',
    },
    titleSmall: {
      fontSize: '14px',
      fontWeight: 500,
      lineHeight: '20px',
      letterSpacing: '0.1px',
    },
    bodyLarge: {
      fontSize: '16px',
      fontWeight: 400,
      lineHeight: '24px',
      letterSpacing: '0.5px',
    },
    bodyMedium: {
      fontSize: '14px',
      fontWeight: 400,
      lineHeight: '20px',
      letterSpacing: '0.25px',
    },
    bodySmall: {
      fontSize: '12px',
      fontWeight: 400,
      lineHeight: '16px',
      letterSpacing: '0.4px',
    },
    labelLarge: {
      fontSize: '14px',
      fontWeight: 500,
      lineHeight: '20px',
      letterSpacing: '0.1px',
    },
    labelMedium: {
      fontSize: '12px',
      fontWeight: 500,
      lineHeight: '16px',
      letterSpacing: '0.5px',
    },
    labelSmall: {
      fontSize: '11px',
      fontWeight: 500,
      lineHeight: '16px',
      letterSpacing: '0.5px',
    },
  },
});
```

### Usage

```tsx
import { Typography } from '@mui/material';

export function Header() {
  return (
    <>
      <Typography variant="displaySmall">Page Title</Typography>
      <Typography variant="headlineSmall">Section Header</Typography>
      <Typography variant="bodyLarge">Body text content goes here.</Typography>
      <Typography variant="labelMedium">Button label</Typography>
    </>
  );
}
```

---

## Spacing System

Material Design 3 uses a **4px base unit**:

```
4, 8, 12, 16, 20, 24, 32, 48, 56, 64, 80, 96 px
```

### Common Spacings

- **4px**: Micro spacing (between related elements)
- **8px**: Small spacing (between items in a list)
- **12px**: Medium-small spacing
- **16px**: Standard spacing (padding, margins)
- **24px**: Large spacing (between sections)
- **32px**: Extra-large spacing (major sections)
- **48px+**: Margins for full-width layouts

### In MUI

```tsx
import { Box } from '@mui/material';

const spacing = (units: number) => `${units * 4}px`;

export function SpacedLayout() {
  return (
    <Box sx={{ p: 6 }}>                           {/* 24px padding */}
      <Box sx={{ mb: 4 }}>                        {/* 16px margin-bottom */}
        <h1>Headline</h1>
      </Box>
      <Box sx={{ display: 'flex', gap: 2 }}>      {/* 8px gap */}
        <div>Item 1</div>
        <div>Item 2</div>
      </Box>
    </Box>
  );
}

// Or with spacing scale:
<Box sx={{
  padding: 6,        // 24px
  marginBottom: 4,   // 16px
  gap: 2,            // 8px
}} />
```

---

## Elevation & Shadows

Material Design 3 defines 5 elevation levels:

| Level | Shadow | Use Case |
|-------|--------|----------|
| 0 | None | Flat surfaces |
| 1 | 0px 1px 2px rgba(0,0,0,0.3), 0px 1px 3px rgba(0,0,0,0.15) | Subtle depth |
| 2 | 0px 3px 6px rgba(0,0,0,0.3), 0px 3px 3px rgba(0,0,0,0.15) | Cards, buttons |
| 3 | 0px 5px 10px rgba(0,0,0,0.3), 0px 5px 5px rgba(0,0,0,0.15) | Dialogs, popovers |
| 4 | 0px 7px 16px rgba(0,0,0,0.3), 0px 7px 7px rgba(0,0,0,0.15) | Modals, floating elements |
| 5 | 0px 11px 24px rgba(0,0,0,0.3), 0px 11px 11px rgba(0,0,0,0.15) | Top-level floating UI |

### In MUI

```tsx
import { Card, Box } from '@mui/material';

export function ElevationExample() {
  return (
    <>
      <Box sx={{ boxShadow: 1, p: 2 }}>Elevation 1</Box>
      <Card elevation={2} sx={{ p: 2 }}>Elevation 2 (Card)</Card>
      <Box sx={{ boxShadow: 3, p: 2 }}>Elevation 3</Box>
      <Dialog PaperProps={{ elevation: 4 }}>Dialog (Elevation 4)</Dialog>
    </>
  );
}
```

---

## Components

Material Design 3 provides a comprehensive component library. The agent uses these common ones:

### Basic Components

- **Button**: Primary, secondary, tertiary, text, outlined, elevated
- **Card**: Container with elevation
- **TextField**: Text input with variants
- **Switch**: Toggle control
- **Checkbox**: Selection control
- **RadioButton**: Single-selection control
- **Chip**: Compact element for tags, filters

### Layout Components

- **AppBar**: Top navigation
- **NavigationBar**: Bottom navigation
- **NavigationRail**: Side navigation
- **Drawer**: Side panel
- **Divider**: Visual separator

### Feedback Components

- **SnackBar**: Brief notification
- **Dialog**: Modal confirmation/input
- **Alert**: Important message
- **LinearProgress**: Progress indicator

### Lists & Tables

- **List**: Vertical list of items
- **Table**: Data display
- **Menu**: Dropdown/context menu

### Example Usage

```tsx
import {
  Card,
  CardContent,
  Button,
  TextField,
  Typography,
  Box,
  Chip,
} from '@mui/material';

export function UserForm() {
  const [name, setName] = React.useState('');
  const [role, setRole] = React.useState('Developer');

  return (
    <Card sx={{ maxWidth: 400, mx: 'auto', mt: 4 }}>
      <CardContent>
        <Typography variant="headlineSmall" sx={{ mb: 3 }}>
          Create User
        </Typography>

        <TextField
          fullWidth
          label="Name"
          variant="outlined"
          value={name}
          onChange={(e) => setName(e.target.value)}
          sx={{ mb: 3 }}
        />

        <Box sx={{ mb: 3 }}>
          <Typography variant="labelMedium" sx={{ mb: 1 }}>
            Role
          </Typography>
          <Box sx={{ display: 'flex', gap: 1 }}>
            <Chip
              label="Developer"
              variant={role === 'Developer' ? 'filled' : 'outlined'}
              onClick={() => setRole('Developer')}
            />
            <Chip
              label="Designer"
              variant={role === 'Designer' ? 'filled' : 'outlined'}
              onClick={() => setRole('Designer')}
            />
          </Box>
        </Box>

        <Button
          variant="contained"
          fullWidth
          onClick={() => console.log({ name, role })}
        >
          Create User
        </Button>
      </CardContent>
    </Card>
  );
}
```

---

## Motion & Animation

Material Design 3 specifies timing and easing for interactions:

### Timing

- **Short**: 150-200ms (quick feedback, micro-interactions)
- **Medium**: 250-300ms (normal interactions)
- **Long**: 350-400ms (complex animations)

### Easing

- **Emphasized**: `cubic-bezier(0.2, 0, 0, 1)` – attention-drawing
- **Standard**: `cubic-bezier(0.4, 0, 0.2, 1)` – general animations
- **Decelerated**: `cubic-bezier(0, 0, 0.2, 1)` – exit animations
- **Accelerated**: `cubic-bezier(0.4, 0, 1, 1)` – entrance animations

### In MUI

```tsx
import { Box } from '@mui/material';

const theme = createTheme({
  transitions: {
    duration: {
      shortest: 150,
      shorter: 200,
      short: 250,
      standard: 300,
      complex: 375,
      enteringScreen: 225,
      leavingScreen: 195,
    },
    easing: {
      easeInOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
      easeOut: 'cubic-bezier(0.0, 0, 0.2, 1)',
      easeIn: 'cubic-bezier(0.4, 0, 1, 1)',
      linear: 'linear',
    },
  },
});

export function FadeButton() {
  const [isVisible, setIsVisible] = React.useState(true);

  return (
    <Box
      sx={{
        opacity: isVisible ? 1 : 0,
        transition: theme.transitions.create('opacity', {
          duration: theme.transitions.duration.standard,
          easing: theme.transitions.easing.easeInOut,
        }),
      }}
    >
      <Button onClick={() => setIsVisible(!isVisible)}>Toggle</Button>
    </Box>
  );
}
```

---

## Accessibility (a11y)

Material Design 3 components include accessibility by default:

- **WCAG AA contrast**: All text meets 4.5:1 ratio for legibility
- **Keyboard navigation**: All interactive elements are keyboard-accessible
- **Screen reader support**: Semantic HTML and ARIA labels
- **Focus indicators**: Visible focus rings for keyboard navigation
- **Motion**: Respects `prefers-reduced-motion` preference

### Best Practices

```tsx
import { Button, TextField, Box } from '@mui/material';

export function AccessibleForm() {
  return (
    <Box component="form" sx={{ p: 3 }}>
      {/* Use labels for all inputs */}
      <TextField
        id="email"
        label="Email Address"
        type="email"
        required
        aria-required="true"
      />

      {/* Descriptive button text */}
      <Button
        variant="contained"
        aria-label="Submit the contact form"
      >
        Submit
      </Button>

      {/* Semantic headings */}
      <h1>Form Title</h1>  {/* Not just styled large text */}
    </Box>
  );
}
```

---

## Quick Reference

### When Creating Components

1. **Check Material Design 3 guidelines**: https://m3.material.io/
2. **Use MUI components**: They implement Material 3 by default
3. **Apply color tokens**: Use theme colors, not hardcoded hex
4. **Follow spacing**: Use 4px multiples (4, 8, 12, 16, 24, etc.)
5. **Respect typography**: Use defined scales (headlineSmall, bodyLarge, etc.)
6. **Add elevation**: Use shadow levels 0-5 for depth
7. **Ensure accessibility**: Keyboard nav, labels, contrast, ARIA
8. **Smooth animations**: 200-300ms transitions with proper easing

### Common Requests

**"Create a card component"**
```tsx
<Card elevation={2}>
  <CardContent>
    <Typography variant="headlineSmall">Title</Typography>
    <Typography variant="bodyMedium">Content</Typography>
  </CardContent>
</Card>
```

**"Add a button"**
```tsx
<Button variant="contained">  {/* Primary */}
<Button variant="outlined">   {/* Secondary */}
<Button variant="text">       {/* Tertiary */}
```

**"Style this container"**
```tsx
<Box sx={{ p: 6, bgcolor: 'background.paper', borderRadius: 2 }}>
```

---

## Resources

- **Material Design 3 Official**: https://m3.material.io/
- **MUI Documentation**: https://mui.com/
- **Material Color Tool**: https://material-foundation.github.io/material-theme-builder/
- **Material Icons**: https://fonts.google.com/icons

---

**The agent follows these guidelines automatically when creating UI components.**
