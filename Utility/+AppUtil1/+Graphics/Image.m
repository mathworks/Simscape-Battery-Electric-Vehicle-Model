classdef Image < AppUtil1.Component.ComponentBase
  % Image component
  %
  % This component wraps uiimage and provides the image's width and height
  % as separate properties from the component's width and height.
  %
  % Use ComponentWidth and ComponentHeight to specify the size of this component.
  % Use ImageWidth and ImageHeight to specify the size of the image within this component.
  %
  % Use HorizontalAlignment and VerticalAlignment to position the image within the component.
  % This class keeps uiimage's HorizontalAlignment and VerticalAlignment as default values
  % (both 'center'). This class provides HorizontalAlignment and VerticalAlignment which
  % work consistently with other App Util components.

  % Copyright 2026 The MathWorks, Inc.

  properties
    MainImage (1,1) matlab.ui.control.Image

    ImageClickedCallback {CodeUtil1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = "1x"
    ImageWidth (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = 18
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = AppUtil1.Constant.Height{"oneline++"}
    ImageHeight (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = 18
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"
  end  % properties

  properties (Dependent)
    % uiimage's ImageSource supports true color image array, but this class does not (by design).
    ImageSource (1,1) string {mustBeFile}
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@AppUtil1.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.RowHeight = {'1x', 'fit', '1x'};
      component.main_grid.ColumnWidth = {'1x', 'fit', '1x'};
      component.main_grid.Padding = component.CommonPadding;
      component.main_grid.ColumnSpacing = component.CommonColumnSpacing;
      component.main_grid.RowSpacing = component.CommonRowSpacing;

      % The main element of this component
      component.MainImage = uiimage(component.main_grid);
      component.MainImage.Layout.Row = 2;
      component.MainImage.Layout.Column = 2;
      component.MainImage.ImageClickedFcn = @(sourceObject, eventData) react_ImageClicked(component);

      % Default settings
      component.ImageSource = which("mus-icon-error.svg");

    end  % function

    function update(component)
      %%
      update@AppUtil1.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.main_grid.RowHeight = {  0,  component.ImageHeight, '1x'};
        case "center"
          component.main_grid.RowHeight = {'1x', component.ImageHeight, '1x'};
        case "bottom"
          component.main_grid.RowHeight = {'1x', component.ImageHeight,   0 };
      end  % switch

      switch component.HorizontalAlignment
        case "left"
          component.main_grid.ColumnWidth = {  0,  component.ImageWidth, '1x'};
        case "center"
          component.main_grid.ColumnWidth = {'1x', component.ImageWidth, '1x'};
        case "right"
          component.main_grid.ColumnWidth = {'1x', component.ImageWidth,   0 };
      end  % switch
    end  % function

  end  % methods

  methods

    function x = get.ImageSource(component)
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = string(component.MainImage.ImageSource);
    end  % function

    function set.ImageSource(component, x)
      arguments (Input)
        component
        x (1,1) string {mustBeFile}
      end  % arguments
      component.MainImage.ImageSource = x;
    end  % function

  end  % methods

  methods (Access=private)

    function react_ImageClicked(component)
      if not(isempty(component.ImageClickedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ImageClickedCallback()
      end  % if
      % To provide ImageClickedFcn property in this component,
      % call notify(component, "ImageClicked") here, and define ImageClicked event variable.
      % This component does not implement it and instead provides simpler ImageClickedCallback.
    end  % function

  end  % methods
end  % classdef
