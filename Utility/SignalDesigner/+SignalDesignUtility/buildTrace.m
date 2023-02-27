function signalObj = buildTrace(nvpairs)

arguments
  nvpairs.RandomSeed (1,1) {mustBeInteger, mustBePositive} = 123
  nvpairs.XScale (1,1) {mustBePositive} = 1
  nvpairs.YScale (1,1) {mustBePositive} = 1
  nvpairs.InterpolationStepSize (1,1) {mustBePositive} = 0.1

  nvpairs.XInitialFlatLength (1,1) {mustBePositive} = 5
  nvpairs.YInitialValue (1,1) double = 0

  nvpairs.NumTransitions (1,1) {mustBeInteger, mustBePositive} = 5 ...
    % Number of transitions excluding initial and final segments

  nvpairs.TransitionRange (1,2) {mustBePositive} = [20 50]
  nvpairs.FlatRange (1,2) {mustBePositive} = [50 100]

  nvpairs.YRange (1,2) double = [0 10]

  nvpairs.XFinalTransitionLength (1,1) {mustBePositive} = 30
  nvpairs.XFinalFlatLength (1,1) {mustBePositive} = 10
  nvpairs.YFinalValue (1,1) double = 0
end

xydata = SignalDesignUtility.buildXYData( ...
  RandomSeed = nvpairs.RandomSeed, ...
  XScale = nvpairs.XScale, ...
  YScale = nvpairs.YScale, ...
  XInitialFlatLength = nvpairs.XInitialFlatLength, ...
  YInitialValue = nvpairs.YInitialValue, ...
  NumTransitions  = nvpairs.NumTransitions, ...
  TransitionRange = nvpairs.TransitionRange, ...
  FlatRange = nvpairs.FlatRange, ...
  YRange = nvpairs.YRange, ...
  XFinalTransitionLength = nvpairs.XFinalTransitionLength, ...
  XFinalFlatLength = nvpairs.XFinalFlatLength, ...
  YFinalValue = nvpairs.YFinalValue );

% Build signal trace
signalObj = SignalDesigner("ContinuousMultiStep");
signalObj.XYData = xydata;
signalObj.DeltaX = nvpairs.InterpolationStepSize;
update(signalObj)

end  % function
