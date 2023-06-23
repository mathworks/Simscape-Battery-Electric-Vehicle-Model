function xydata = buildXYData(nvpairs)

arguments
  nvpairs.RandomSeed (1,1) {mustBeInteger, mustBePositive} = 123
  nvpairs.XScale (1,1) {mustBePositive} = 1
  nvpairs.YScale (1,1) {mustBePositive} = 1

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

xScale = nvpairs.XScale;
yScale = nvpairs.YScale;

xIni_2 = nvpairs.XInitialFlatLength;
xTransitionFinal = nvpairs.XFinalTransitionLength;

rng(nvpairs.RandomSeed)

N = nvpairs.NumTransitions;

% First column
r1 = randi(nvpairs.TransitionRange, N, 1);

% Second column
r2 = randi(nvpairs.FlatRange, N, 1);

x = nan(N*2, 1);
x(1:2:end-1) = r1;
x(2:2:end) = r2;
x = (cumsum(x) + xIni_2) / xScale;

x1 = x(1:2:end);
x2 = x(2:2:end);

y = randi(nvpairs.YRange, N, 1) / yScale;

middleRows = horzcat(x1, x2, y);

initialRow = [0, xIni_2/xScale, nvpairs.YInitialValue/yScale];

xFinal_1 =  x2(end) + xTransitionFinal/xScale;
xFinal_2 = xFinal_1 + nvpairs.XFinalFlatLength/xScale;
finalRow = [ xFinal_1, xFinal_2, nvpairs.YFinalValue ];

xydata = vertcat(initialRow, middleRows, finalRow);

end  % function
