# LiteApp API version 7

Version 7 for MATLAB R2025a or newer

August 2025

![LiteApp Logo](+LiteApp7/LiteApp-icon-150x150.png)

This is **LiteApp API**, MATLAB application programming interface (API)
to build apps programatically using [`uifigure`][url-uifig] and
[`uigridlayout`][url-uigrid].
LiteApp API provides a thin layer between MATLAB UI functions and
your app code so that your code can focus on app features while
implementation details, such as interaction with base workspace,
error handling, and the spacing and alignment of UI components,
are handled by the API.

To use LiteApp API, your MATLAB paths must include a folder
which contains the `+LiteApp7` folder.

The main window in LiteApp is `uifigure`.
Components in LiteApp are placed in `uigridlayout` using
LiteApp's component placement logic
which makes it quick and easy to build
apps with consistent look and feel.

LiteApp's highlights

- Programmatic app building approach to create `uifigure`-based apps
- Simple-but-reasonably-flexible logic to add UI components for
  `uigridlayout`, which makes it easy to align UI components
  and to conform to keyboard navigation accessibility
- UI components that are pre-adjusted for use with `uigridlayout`
- Consistent sizes and spacings defined in all Lite App components to
  quickly build apps with a consistent look and feel
  and to reduce the amount of code you write
- Easy to configure the way the size of UI components change
  against window size change
- LaTeX text by default wherever possible
- Composite UI components for typical App use cases.
- Streamlined error handling and interaction with base workspace in some UI components

Limitations

- Font size is fixed.
- Internationalization (i18n) support is not available.

_Copyright 2023-2025 The MathWorks, Inc._

[url-uifig]: https://www.mathworks.com/help/matlab/ref/uifigure.html
[url-uigrid]: https://www.mathworks.com/help/matlab/ref/uigridlayout.html
