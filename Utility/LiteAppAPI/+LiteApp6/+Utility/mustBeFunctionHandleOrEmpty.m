function mustBeFunctionHandleOrEmpty(x)

% Copyright 2024-2025 The MathWorks, Inc.

if not(isa(x, 'function_handle')) && not(isempty(x))
  error_id = "Type:notCorrectType";
  error_message = "Input must be a function handle or empty.";
  throw(MException(error_id, error_message))
end  % if

end  % function
