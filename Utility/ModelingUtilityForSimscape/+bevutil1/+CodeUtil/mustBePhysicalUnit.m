function mustBePhysicalUnit(a)

% Copyright 2026 The MathWorks, Inc.

try
  simscape.Unit(a);
catch exception

  rethrow(exception)

end  % try, catch
end  % function
