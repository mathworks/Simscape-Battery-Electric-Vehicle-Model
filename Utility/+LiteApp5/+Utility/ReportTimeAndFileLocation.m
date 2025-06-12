function ReportTimeAndFileLocation(ReportString, NameValuePairs)

% Copyright 2024 The MathWorks, Inc.

arguments
  ReportString = ""
  NameValuePairs.Keyword = ""
end  % arguments

reporting_time = string(datetime("now", TimeZone="UTC", Format="yyyy-MM-dd|HH:mm:ss.SSS"));

if NameValuePairs.Keyword ~= ""
  kwd = NameValuePairs.Keyword + ":";
else
  kwd = "";
end  % if

info = dbstack;

if numel(info) >= 3

  s = "|" + kwd + info(3).name + "|line:" + info(3).line + ...
    "|>" + info(2).name + "|line:" + info(2).line;

  disp("utc:" + reporting_time + s + "|[" + ReportString + "]")

  return

elseif numel(info) == 2
  % Assume that this function was called from a class method.
  StackLevel = 2;

else
  % This function was directly called, for example by running in the Editor
  % or on the Command Window.
  assert(isscalar(info))
  StackLevel = 1;

end  % if

disp("utc:" + reporting_time + "|" + kwd + info(StackLevel).name + "|line:" + info(StackLevel).line + "|[" + ReportString + "]")

end  % function
