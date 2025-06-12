function jsonText = buildJSONTextFromAppConfig(AppConfigObj, NameValuePair)
%%
% This function converts an AppConfig class object to a text string in JSON format.
% AppConfig is defined as a class which meets the following conditions.
%
% - The class name ends with "AppConfig".
% - The class has properties in a simple flat structure.
%
% This function and conditions on AppConfig class are designed to support
% apps for visualizing parameter values of a Simscape block.
%
% For example, an AppConfig class would look as follows.
%
% classdef MySampleAppConfig < handle
%   properties
%     Param1 (1,1) double  % Scalar parameter
%     Param2 (1,:) double  % Vector parameter
%   end
% end

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  AppConfigObj (1,1) {LiteApp5.Utility.mustBeAppConfig}
  NameValuePair.AddTimeInfo matlab.lang.OnOffSwitchState = "on"
end

arguments (Output)
  jsonText (1,1) string
end

% The text below says "this file" because the intended use of the return value
% from this function is to save it in a file. 
comment_text = join([
  "// App config"
  "// This file was programmatically generated."
  ], newline);

if NameValuePair.AddTimeInfo
  % Format="yyyy-MM-dd HH:mm:ss.SSS"
  time_info = "// UTC " + string(datetime("now", TimeZone="UTC", Format="yyyy-MM-dd HH:mm:ss"));
  comment_text = comment_text + newline + time_info;
end  % if

config_names = string(properties(AppConfigObj));
num_names = numel(config_names);
lines = strings(num_names, 1);
for ii = 1 : num_names
  name = config_names(ii);
  lines(ii) = """" + name + """: """ + AppConfigObj.(name) + """";
end  % for

jsonText = comment_text + newline + "{" + newline + join(lines, ","+newline) + newline + "}";

end  % function
