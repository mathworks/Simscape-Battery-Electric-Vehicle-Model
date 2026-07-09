classdef Constant
  % Constants for basic elements
  
  % FYI:
  %
  % For interactive icons (buttons, controls, links)
  %
  % WCAG defines minimum target sizes for any pointer‑operable control, including icon-only buttons.
  %
  % WCAG 2.2
  %
  % - Level AA (2.5.8 – Target Size (Minimum))
  %   - At least 24 × 24 pixels
  %   - Spacing can count if the icon itself is smaller
  %   - Exceptions exist (inline text links, equivalent controls, essential designs)
  %
  % - Level AAA (2.5.5 – Target Size)
  %   - At least 44 × 44 pixels
  %   - Often cited as a best practice for touch and motor accessibility
  %
  % - If an icon is clickable, these sizes apply to the click/tap area, not necessarily the visible glyph.

  % Copyright 2023-2026 The MathWorks, Inc.

  properties (Constant)

    Width = dictionary("unitwidth", {10});

    Height = dictionary(["oneline", "oneline+", "oneline++"], {20.9, 22, 25})

    FontSize = dictionary("medium", {14})

  end  % properties
end  % classdef
